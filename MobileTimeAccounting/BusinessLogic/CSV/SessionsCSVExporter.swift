/*
    Mobile Time Accounting
    Copyright (C) 2015

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation


class SessionsCSVExporter
{
    let csvBuilder = CSVBuilder()
    let dateFormatter = NSDateFormatter()
    let calendar = NSCalendar.currentCalendar()
    var month = 0
    var year = 0
    
    var projects = [Project]()
    var sessions = [[Session]]()
    
    
    /*
        Constructor, setting up date formatter.
        
        @methodtype Constructor
        @pre Date formatter has been initialized
        @post Date formatter is set up
    */
    init()
    {
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
    }
    
    
    /*
        Exports all sessions of a given month in a given year as csv file.
        
        @methodtype Helper
        @pre Valid values for month (>0) and year
        @post Returns csv file as NSData
    */
    func exportCSV(month: Int, year: Int)->NSData
    {
        self.month = month
        self.year = year
        
        let csvString = doExportCSV()
        return csvString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    }
    
    
    /*
        Exports all sessions of a given month in a given year as csv string by using CSVBuilder.
        
        @methodtype Command
        @pre CSVBuilder has been initialized
        @post Returns csv string
    */
    func doExportCSV()->String
    {
        setHeading()
        setProjectsRow()
        setSessionRows()

        return csvBuilder.build()
    }
    
    
    /*
        Sets heading of csv file like: 'profile_firstname','profile_lastname','month','year'
        
        @methodtype Command
        @pre Profile has been set
        @post Heading is set
    */
    private func setHeading()
    {
        let profile = profileDAO.getProfile()!
        csvBuilder.addRow(profile.firstname, profile.lastname, String(month), String(year))
    }
    
    
    /*
        Sets all active projects of the given month into a row like: '','project1','project2',...
    
        @methodtype Command
        @pre Active projects are available
        @post Projects are added into row
    */
    private func setProjectsRow()
    {
        projects = projectDAO.getProjects(month, year: year)
        
        csvBuilder.addRow("")
        for project in projects
        {
            csvBuilder.addRowItem(1, rowItem: project.name)
            sessions.append(sessionDAO.getSessions(project, month: month, year: year))
        }
    }
    
    
    /*
        Sets all dates of all session rows of the given month like: '1/1/2015','8'
                                                                    '1/2/2015','0'
                                                                    ...
        
        @methodtype Command
        @pre -
        @post All session rows are set
    */
    private func setSessionRows()
    {
        var currentRow = 2
        let startOfMonth = NSDate(month: month, year: year, calendar: calendar).startOfMonth()!
        let endOfMonth = NSDate(month: month, year: year, calendar: calendar).endOfMonth()!
        
        for var date = startOfMonth; date.timeIntervalSince1970 < endOfMonth.timeIntervalSince1970; date = date.dateByAddingDays(1)!
        {
            csvBuilder.addRow(dateFormatter.stringFromDate(date))
            setSessionRow(date, rowIndex: currentRow)
            currentRow++
        }
    }
    
    
    /*
        Sets accumulated times of all sessions into csv rows.
        
        @methodtype Command
        @pre -
        @post Accumulated times of all sessions are set
    */
    private func setSessionRow(date: NSDate, rowIndex: Int)
    {
        for var columnIndex = 1; columnIndex <= sessions.count; ++columnIndex
        {
            var accumulatedTime = 0
            for session in sessions[columnIndex-1]
            {
                if calendar.components(.CalendarUnitDay, fromDate: session.startTime).day == calendar.components(.CalendarUnitDay, fromDate: date).day
                {
                    accumulatedTime += (Int(session.endTime.timeIntervalSince1970 - session.startTime.timeIntervalSince1970))/60/60
                }
            }
            csvBuilder.setRowItem(rowIndex, rowItemIndex: columnIndex, rowItem: String(accumulatedTime))
        }
    }
}
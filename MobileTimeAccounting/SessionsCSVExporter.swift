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
    var month = 0
    var year = 0
    
    
    init()
    {
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    
    func exportCSV(month: Int, year: Int)->NSData
    {
        self.month = month
        self.year = year
        
        let csvString = doExportCSV()
        return csvString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    }
    
    
    func doExportCSV()->String
    {
        setHeading()
        setProjectColumns()
        return csvBuilder.build()
    }
    
    
    private func setHeading()
    {
        let profile = profileDAO.getProfile()!
        csvBuilder.addRow(profile.firstname, profile.lastname, String(month), String(year))
    }
    
    
    private func setProjectColumns()
    {
        //Need to replace with other function
        let projects = projectDAO.getProjects()
        
        for index in 1...projects.count
        {
            setProjectColumn(projects[index-1], columnIndex: index)
        }
    }
    
    
    private func setProjectColumn(project: Project, columnIndex: Int)
    {
        //set project column header
        csvBuilder.setRowItem(2, rowItemIndex: columnIndex, rowItem: project.name)
        
        var currentRow = 3
        //Need to replace with other function
        let sessions = sessionDAO.getSessions(project)
        
        for session in sessions
        {
            //set date for row
            csvBuilder.addRowItem(currentRow, rowItem: dateFormatter.stringFromDate(session.startTime))
            
            //set accumulated time in row
            let accumulatedTime = (Int(session.endTime.timeIntervalSince1970 - session.startTime.timeIntervalSince1970))
            csvBuilder.setRowItem(currentRow, rowItemIndex: columnIndex, rowItem: String(accumulatedTime))
            
            currentRow++
        }
    }
}
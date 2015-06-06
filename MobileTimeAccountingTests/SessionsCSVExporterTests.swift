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

import XCTest


class SessionsCSVExporterTests: XCTestCase
{
    let calendar = NSCalendar.currentCalendar()
    var projects = [Project]()
    var csvData = NSData()
    let csvString = ""
    
    
    override func setUp()
    {
        super.setUp()
        
        setUpProfile()
        setUpProject1()
        setUpProject2()
        csvData = csvString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    }
    
    
    func setUpProfile()
    {
        profileDAO.setProfile(Profile(firstname: "Max", lastname: "Mueller", employeeId: "12345", weeklyWorkingTime: "30", totalVacationTime: "40", currentVacationTime: "10", currentOvertime: "20"))
    }
    
    
    func setUpProject1()
    {
        let project1 = Project(id: "10001", name: "Test Project 1", finalDate: NSDate(day: 2, month: 2, year: 2015, calendar: calendar))
        projects.append(project1)
        projectDAO.addProject(project1)
        
        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 29, month: 1, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 29, month: 1, year: 2015, calendar: calendar)), project: project1)
        
        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 30, month: 1, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 30, month: 1, year: 2015, calendar: calendar)), project: project1)
    }
    
    
    func setUpProject2()
    {
        let project2 = Project(id: "10002", name: "Test Project 2", finalDate: NSDate(day: 3, month: 3, year: 2015, calendar: calendar))
        projects.append(project2)
        projectDAO.addProject(project2)
        
        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 20, month: 1, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 20, month: 1, year: 2015, calendar: calendar)), project: project2)
        
        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 21, month: 1, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 21, month: 1, year: 2015, calendar: calendar)), project: project2)
        
        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 22, month: 1, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 22, month: 1, year: 2015, calendar: calendar)), project: project2)
    }
    
    
    override func tearDown()
    {
        profileDAO.removeProfile()
        
        for project in projects
        {
            if let project = projectDAO.getProject(project.id)
            {
                sessionDAO.removeSessions(project)
                projectDAO.removeProject(project)
            }
        }
        projects.removeAll(keepCapacity: false)
        
        super.tearDown()
    }

    
    func testExportCSV_ProjectsAndSessionsAreAvailable_CSVCreatedAndValid()
    {
        let sessionCSVExporter = SessionsCSVExporter()
        let csvData = sessionCSVExporter.exportCSV(1, year: 2015)
        
        XCTAssert(csvData == self.csvData, "Pass")
    }
}

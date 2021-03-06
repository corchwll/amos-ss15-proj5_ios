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

/*
    Naming convention for all tests: 'UnitOfWork_StateUnderTest_ExpectedBehavior'
*/
class SessionsCSVExporterTests: XCTestCase
{
    let calendar = NSCalendar.currentCalendar()
    var projects = [Project]()
    let csvString1 = "Max;Mueller;1;2015\n;Test Project 1;Test Project 2;\n1/1/15;0;0;\n1/2/15;0;0;\n1/3/15;0;0;\n1/4/15;0;0;\n1/5/15;0;0;\n1/6/15;0;0;\n1/7/15;0;0;\n1/8/15;0;0;\n1/9/15;0;0;\n1/10/15;0;0;\n1/11/15;0;0;\n1/12/15;0;0;\n1/13/15;0;0;\n1/14/15;0;0;\n1/15/15;0;0;\n1/16/15;0;0;\n1/17/15;0;0;\n1/18/15;0;0;\n1/19/15;0;0;\n1/20/15;0;8;\n1/21/15;0;8;\n1/22/15;0;8;\n1/23/15;0;0;\n1/24/15;0;0;\n1/25/15;0;0;\n1/26/15;0;0;\n1/27/15;0;0;\n1/28/15;0;0;\n1/29/15;8;0;\n1/30/15;8;0;\n1/31/15;0;0;\n"
    let csvString2 = "Max;Mueller;2;2015\n;;;\n2/1/15;;;\n2/2/15;;;\n2/3/15;;;\n2/4/15;;;\n2/5/15;;;\n2/6/15;;;\n2/7/15;;;\n2/8/15;;;\n2/9/15;;;\n2/10/15;;;\n2/11/15;;;\n2/12/15;;;\n2/13/15;;;\n2/14/15;;;\n2/15/15;;;\n2/16/15;;;\n2/17/15;;;\n2/18/15;;;\n2/19/15;;;\n2/20/15;;;\n2/21/15;;;\n2/22/15;;;\n2/23/15;;;\n2/24/15;;;\n2/25/15;;;\n2/26/15;;;\n2/27/15;;;\n2/28/15;;;\n"
    
    
    override func setUp()
    {
        super.setUp()
        
        setUpProfile()
        setUpProject1()
        setUpProject2()
    }
    
    
    func setUpProfile()
    {
        profileDAO.setProfile(Profile(firstname: "Max", lastname: "Mueller", employeeId: "12345", weeklyWorkingTime: 30, totalVacationTime: 40, currentVacationTime: 10, currentOvertime: 20))
    }
    
    
    func setUpProject1()
    {
        let project1 = Project(id: "10001", name: "Test Project 1")
        projects.append(project1)
        projectDAO.addProject(project1)
        
        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 29, month: 1, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 29, month: 1, year: 2015, calendar: calendar)), project: project1)
        
        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 30, month: 1, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 30, month: 1, year: 2015, calendar: calendar)), project: project1)
    }
    
    
    func setUpProject2()
    {
        let project2 = Project(id: "10002", name: "Test Project 2")
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
       
        XCTAssert(csvData == csvString1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), "Pass")
    }
    
    
    func testExportCSV_ProjectsAndSessionsAreNotAvailable_CSVCreatedAndValidButWithoutSessionData()
    {
        let sessionCSVExporter = SessionsCSVExporter()
        let csvData = sessionCSVExporter.exportCSV(2, year: 2015)
        
        XCTAssert(csvData == csvString2.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), "Pass")
    }
}

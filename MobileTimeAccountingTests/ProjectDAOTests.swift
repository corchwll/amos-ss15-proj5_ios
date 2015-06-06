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

import UIKit
import XCTest


/*
    Naming convention for all tests: 'UnitOfWork_StateUnderTest_ExpectedBehavior'
*/
class ProjectDAOTests: XCTestCase
{
    let calendar = NSCalendar.currentCalendar()
    var projects: [Project] = []
    
    
    override func setUp()
    {
        super.setUp()
        
        setUpProject1()
        setUpProject2()
        setUpProject3()
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
        
        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 24, month: 2, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 24, month: 2, year: 2015, calendar: calendar)), project: project2)
        
        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 25, month: 2, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 25, month: 2, year: 2015, calendar: calendar)), project: project2)
    }
    
    
    func setUpProject3()
    {
        let project3 = Project(id: "10003", name: "Test Project 3")
        projects.append(project3)
        projectDAO.addProject(project3)

        sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 17, month: 3, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 17, month: 3, year: 2015, calendar: calendar)), project: project3)
    }
 
    
    override func tearDown()
    {
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

    
    func testAddProject_ValidProjects_ProjectsAdded()
    {
        var pass = true
        for project in projects
        {
            if let project = projectDAO.getProject(project.id)
            {
                pass = pass && projectDAO.getProject(project.id)!.id == project.id
            }
            else
            {
                pass = false
            }
        }

        XCTAssert(pass, "Pass")
    }
    
    
    func testGetProject_ValidProjectsAdded_GetAllProjects()
    {
        var pass = true
        for project in projects
        {
            if let requestedProject = projectDAO.getProject(project.id)
            {
                pass = pass && requestedProject.id == project.id
                pass = pass && requestedProject.name == project.name
                pass = pass && requestedProject.finalDate.timeIntervalSince1970 == project.finalDate.timeIntervalSince1970
                pass = pass && requestedProject.isArchived == project.isArchived
            }
            else
            {
                pass = false
            }
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testGetProjects_ValidProjectsAdded_GetAllProjects()
    {
        var pass = true
        for project in projectDAO.getProjects()
        {
            if projects.filter({(p: Project)->Bool in return p.id == project.id}).isEmpty
            {
                pass = false
            }
        }
        
        XCTAssert(!pass, "Pass")
    }
    
    
    func testArchiveProject_ValidProjectsWereAdded_ProjectsAreArchived()
    {
        for project in projects
        {
            projectDAO.archiveProject(project)
        }
        
        var pass = true
        for project in projects
        {
            if let project = projectDAO.getProject(project.id)
            {
                pass = pass && projectDAO.getProject(project.id)!.isArchived
            }
            else
            {
                pass = false
            }
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testRemoveProject_ValidProjectsWereAdded_AllProjectsAndSessionsAreRemoved()
    {
        for project in projects
        {
            sessionDAO.removeSessions(project)
            projectDAO.removeProject(project)
        }
        
        var pass = true
        for project in projects
        {
            if let project = projectDAO.getProject(project.id)
            {
                pass = false
            }
            else
            {
                pass = pass && true
            }
        }
        
        XCTAssert(pass, "Pass")
    }
}

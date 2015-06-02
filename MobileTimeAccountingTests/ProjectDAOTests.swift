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
    var projects: [Project] = []
    
    
    override func setUp()
    {
        super.setUp()
        
        let finalDate = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        
        finalDate.day = 1
        finalDate.month = 1
        finalDate.year = 2015
        projects.append(Project(id: "10001", name: "Test Project 1", finalDate: calendar.dateFromComponents(finalDate)!))

        finalDate.day = 2
        finalDate.month = 2
        finalDate.year = 2015
        projects.append(Project(id: "10002", name: "Test Project 2", finalDate: calendar.dateFromComponents(finalDate)!))

        projects.append(Project(id: "10003", name: "Test Project 3"))
    }
 
    
    override func tearDown()
    {
        for project in projects
        {
            if let project = projectDAO.getProject(project.id)
            {
                projectDAO.removeProject(project)
            }
        }
        projects.removeAll(keepCapacity: false)
        
        super.tearDown()
    }

    
    func testAddProject_ValidProjects_ProjectsAdded()
    {
        for project in projects
        {
            projectDAO.addProject(project)
        }
        
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
    
    
    func testAddProject_MissingProject_FoundNilBecauseOfMissingProject()
    {
        projectDAO.addProject(projects[0])
        projectDAO.addProject(projects[1])
        
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
        
        XCTAssert(!pass, "Pass")
    }

    
    func testGetProject_ValidProjectsAdded_GetAllProjects()
    {
        for project in projects
        {
            projectDAO.addProject(project)
        }
        
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
    
    
    func testGetProject_NoProjectWasAdded_NoProjectCanBeFound()
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
        
        XCTAssert(!pass, "Pass")
    }
    
    
    func testArchiveProject_ValidProjectsWereAdded_ProjectsAreArchived()
    {
        for project in projects
        {
            projectDAO.addProject(project)
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
    
    
    func testArchiveProject_NotAllProjectsWereAdded_AvailabeProjectsAreArchived()
    {
        projectDAO.addProject(projects[0])
        projectDAO.addProject(projects[1])
        
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
        
        XCTAssert(!pass, "Pass")
    }
    
    
    func testRemoveProject_ValidProjectsWereAdded_AllProjectsAreRemoved()
    {
        for project in projects
        {
            projectDAO.addProject(project)
        }
        
        
        for project in projects
        {
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

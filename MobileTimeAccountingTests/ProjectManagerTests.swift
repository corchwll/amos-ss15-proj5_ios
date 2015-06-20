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
import MapKit
import XCTest


/*
    Naming convention for all tests: 'UnitOfWork_StateUnderTest_ExpectedBehavior'
*/
class ProjectManagerTests: XCTestCase
{
    let projectManager = ProjectManager()
    var projects = [Project]()
    let currentLocation = CLLocation(latitude: 43.252300, longitude: 43.234400) //43.252300, 43.234400
    
    
    override func setUp()
    {
        super.setUp()

        //43.091208, 43.239200
        let project1 = Project(id: "10001", name: "Test Project 1 ; Position 3", finalDate: NSDate(), latitude: 43.091208, longitude: 43.239200)
        projects.append(project1)
        
        //43.289329, 43.474719
        let project2 = Project(id: "10002", name: "Test Project ; Position 4", finalDate: NSDate(), latitude: 43.289329, longitude: 43.474719)
        projects.append(project2)
        
        //43.485431, 42.617277
        let project3 = Project(id: "10003", name: "Test Project ; Position 6", finalDate: NSDate(), latitude: 43.485431, longitude: 42.617277)
        projects.append(project3)
        
        //43.245142, 43.169505
        let project4 = Project(id: "10004", name: "Test Project ; Position 1", finalDate: NSDate(), latitude: 43.245142, longitude: 43.169505)
        projects.append(project4)
        
        //43.443319, 43.155950
        let project5 = Project(id: "10005", name: "Test Project ; Position 5", finalDate: NSDate(), latitude: 43.443319, longitude: 43.155950)
        projects.append(project5)
        
        //43.195793, 43.170192
        let project6 = Project(id: "10006", name: "Test Project ; Position 2", finalDate: NSDate(), latitude: 43.195793, longitude: 43.170192)
        projects.append(project6)
        
        for project in projects
        {
            projectDAO.addProject(project)
        }
    }
    
    
    override func tearDown()
    {
        for project in projects
        {
            projectDAO.removeProject(project)
        }
        projects.removeAll(keepCapacity: false)
        
        super.tearDown()
    }

    
    func testGetProjectsSortedByDistance_Valid_GetProjectsSortedByDistanceToCurrentPosition()
    {
        var pass = true
        let sortedProjects = projectManager.getProjectsSortedByDistance(currentLocation)
        
        pass = pass && projects[3].id == sortedProjects[0].id
        pass = pass && projects[5].id == sortedProjects[1].id
        pass = pass && projects[0].id == sortedProjects[2].id
        pass = pass && projects[1].id == sortedProjects[3].id
        pass = pass && projects[4].id == sortedProjects[4].id
        pass = pass && projects[2].id == sortedProjects[5].id
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testGetProjectsSortedByDistance_WrongProjectOrderComparison_SortedProjectsNotEqualGivenProjectOrder()
    {
        var pass = false
        let sortedProjects = projectManager.getProjectsSortedByDistance(currentLocation)
        
        pass = pass || projects[5].id == sortedProjects[0].id
        pass = pass || projects[4].id == sortedProjects[1].id
        pass = pass || projects[3].id == sortedProjects[2].id
        pass = pass || projects[2].id == sortedProjects[3].id
        pass = pass || projects[1].id == sortedProjects[4].id
        pass = pass || projects[0].id == sortedProjects[5].id
        
        XCTAssert(!pass, "Pass")
    }
}

//
//  ProjectDAOTests.swift
//  MobileTimeRecording
//
//  Created by cdan on 25/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit
import XCTest

class ProjectDAOTests: XCTestCase
{
    var projects: [Project] = []
    
    override func setUp()
    {
        super.setUp()
        
        projects.append(Project(id: "10001", name: "Test Project 1", finalDate: NSDate()))
        projects.append(Project(id: "10002", name: "Test Project 2", finalDate: NSDate()))
        projects.append(Project(id: "10003", name: "Test Project 3", finalDate: NSDate()))
    }
 
    
    override func tearDown()
    {
        super.tearDown()
    }

    
    func testAddProject_Valid_Pass()
    {
        var pass = true
        for project in projects
        {
            projectDAO.addProject(project)
            pass = pass && projectDAO.getProject(project.id).id == project.id
        }

        XCTAssert(pass, "Pass")
    }
}

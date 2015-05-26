//
//  ProjectDAOTests.swift
//  MobileTimeRecording
//
//  Created by cdan on 25/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

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
        
        projects.append(Project(id: "10001", name: "Test Project 1", finalDate: NSDate()))
        projects.append(Project(id: "10002", name: "Test Project 2", finalDate: NSDate()))
        projects.append(Project(id: "10003", name: "Test Project 3", finalDate: NSDate()))
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
        projectDAO.addProject(projects[0])
        
        var pass = true
        if let project = projectDAO.getProject(projects[0].id)
        {
            pass = pass && projectDAO.getProject(project.id)!.id == project.id
        }
        else
        {
            pass = false
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
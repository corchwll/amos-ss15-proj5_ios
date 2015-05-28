//
//  SessionDAOTests.swift
//  MobileTimeRecording
//
//  Created by cdan on 26/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit
import XCTest

class SessionDAOTests: XCTestCase
{
    var projects: [Project] = []
    var sessions: [Session] = []

    
    override func setUp()
    {
        super.setUp()
        
        projects.append(Project(id: "10001", name: "Test Project1", finalDate: NSDate()))
        projects.append(Project(id: "10002", name: "Test Project2", finalDate: NSDate()))
        
        sessions.append(Session(id: 0, startTime: NSDate(timeIntervalSinceReferenceDate: 10), endTime: NSDate(timeIntervalSinceReferenceDate: 20)))
        sessions.append(Session(id: 0, startTime: NSDate(timeIntervalSinceReferenceDate: 30), endTime: NSDate(timeIntervalSinceReferenceDate: 40)))
        sessions.append(Session(id: 0, startTime: NSDate(timeIntervalSinceReferenceDate: 40), endTime: NSDate(timeIntervalSinceReferenceDate: 60)))
    }
    
    
    override func tearDown()
    {
        for project in projects
        {
            sessionDAO.removeSessions(project)
            projectDAO.removeProject(project)
        }
        projects.removeAll(keepCapacity: false)
        sessions.removeAll(keepCapacity: false)
        
        super.tearDown()
    }
    

    func testAddSession_ProjectIsExisting_SessionsWereAddedToProject()
    {
        let project = projects.first!
        
        projectDAO.addProject(project)
        for session in sessions
        {
            sessionDAO.addSession(session, project: project)
        }
        
        var pass = true
        for requestedSession in sessionDAO.getSessions(project)
        {
            var hasElement = false
            for session in sessions
            {
                if requestedSession.startTime == session.startTime && requestedSession.endTime == session.endTime
                {
                    hasElement = true
                }
            }
            pass = pass && hasElement
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testAddSession_ProjectIsNotExisting_SessionsWereNotAdded()
    {
        let project = projects.first!
        for session in sessions
        {
            sessionDAO.addSession(session, project: project)
        }
        
        var pass = true
        if !sessionDAO.getSessions(project).isEmpty
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testAddSession_MultipleProjectsWithMultipleSessions_SessionsWereAddedToProjects()
    {
        for project in projects
        {
            projectDAO.addProject(project)
            for session in sessions
            {
                sessionDAO.addSession(session, project: project)
            }
        }
        
        var pass = true
        for project in projects
        {
            for requestedSession in sessionDAO.getSessions(project)
            {
                var hasElement = false
                for session in sessions
                {
                    if requestedSession.startTime == session.startTime && requestedSession.endTime == session.endTime
                    {
                        hasElement = true
                    }
                }
                pass = pass && hasElement
            }
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testGetAllSessions_MultipleProjectsWithSessions_AllSessionsWereReturned()
    {
        for project in projects
        {
            projectDAO.addProject(project)
            for session in sessions
            {
                sessionDAO.addSession(session, project: project)
            }
        }
        
        var pass = true
        for session in sessions
        {
            var hasElement = 0
            for requestedSession in sessionDAO.getAllSessions()
            {
                if requestedSession.startTime == session.startTime && requestedSession.endTime == session.endTime
                {
                    hasElement += 1
                }
            }
            pass = pass && hasElement == projects.count
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testRemoveSession_ValidProject_SessionsWereRemoved()
    {
        let project = projects.first!
        projectDAO.addProject(project)
        
        for session in sessions
        {
            sessionDAO.addSession(session, project: project)
        }
        
        for session in sessionDAO.getSessions(project)
        {
            sessionDAO.removeSession(session)
        }
        
        var pass = false
        if sessionDAO.getSessions(project).isEmpty
        {
            pass = true
        }
        
        XCTAssert(pass, "Pass")
    }
}

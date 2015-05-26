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
        
        sessions.append(Session(id: 0, startTime: NSDate(), endTime: NSDate()))
        sessions.append(Session(id: 0, startTime: NSDate(), endTime: NSDate()))
        sessions.append(Session(id: 0, startTime: NSDate(), endTime: NSDate()))
    }
    
    override func tearDown()
    {
        projects.removeAll(keepCapacity: false)
        sessions.removeAll(keepCapacity: false)
        
        super.tearDown()
    }

    func testExample()
    {
        XCTAssert(true, "Pass")
    }
}

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
class SessionManagerTests: XCTestCase
{
    let calendar = NSCalendar.currentCalendar()
    let project = Project(id: "12345", name: "Test Project 1")
    var sessions = [Session]()
    
    
    override func setUp()
    {
        super.setUp()

        projectDAO.addProject(project)
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 12, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 10, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 18, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 18, minute: 30, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 20, minute: 30, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 21, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 23, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
    }
    
    
    override func tearDown()
    {
        sessionDAO.removeSessions(project)
        projectDAO.removeProject(project)
        sessions.removeAll(keepCapacity: false)
        
        super.tearDown()
    }

    
    func testAddSession_ValidSessionState_SessionIsAdded()
    {
        var pass = sessionManager.addSession(self.sessions[0], project: project)
        
        let sessions = sessionDAO.getSessions(project)
        if sessions.count == 1
        {
            let session = sessions.first!
            pass = pass || session.startTime == self.sessions[0].startTime && session.endTime == self.sessions[0].endTime
        }
        else
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testAddSession_OverlappingSession_NewSessionIsNotAdded()
    {
        sessionManager.addSession(self.sessions[0], project: project)
        var pass = !sessionManager.addSession(self.sessions[1], project: project)
        
        let sessions = sessionDAO.getSessions(project)
        if sessions.count == 1
        {
            let session = sessions.first!
            pass = pass || session.startTime == self.sessions[0].startTime && session.endTime == self.sessions[0].endTime
        }
        else
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testAddSession_SessionLimitReached_NewSessionIsNotAdded()
    {
        sessionManager.addSession(self.sessions[1], project: project)
        sessionManager.addSession(self.sessions[2], project: project)
        var pass = !sessionManager.addSession(self.sessions[3], project: project)
        
        let sessions = sessionDAO.getSessions(project)
        if sessions.count == 2
        {
            let session = sessions.first!
            pass = pass || session.startTime == self.sessions[1].startTime && session.endTime == self.sessions[1].endTime
            pass = pass || session.startTime == self.sessions[2].startTime && session.endTime == self.sessions[2].endTime
        }
        else
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testAddSession_SessionLimitLeft_SessionIsAddedButCutOff()
    {
        sessionManager.addSession(self.sessions[1], project: project)
        var pass = !sessionManager.addSession(self.sessions[3], project: project)
        
        let sessions = sessionDAO.getSessions(project)
        if sessions.count == 2
        {
            let session = sessions.first!
            pass = pass || session.startTime == self.sessions[1].startTime && session.endTime == self.sessions[1].endTime
            pass = pass || session.startTime == self.sessions[3].startTime
        }
        else
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
}

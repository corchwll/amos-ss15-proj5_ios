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
    let project = Project(id: "12345", name: "Test Project 1", finalDate: NSDate(day: 18, month: 11, year: 2015, calendar: NSCalendar.currentCalendar()), latitude: nil, longitude: nil)
    var sessions = [Session]()
    var dates = [NSDate]()
    
    
    override func setUp()
    {
        super.setUp()

        projectDAO.addProject(project)
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 12, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 10, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 18, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 18, minute: 30, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 20, minute: 30, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 21, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 23, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 19, month: 11, year: 2015, calendar: calendar), endTime: NSDate(hour: 10, minute: 0, second: 0, day: 19, month: 11, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 23, minute: 0, second: 0, day: 18, month: 11, year: 2015, calendar: calendar), endTime: NSDate(hour: 7, minute: 0, second: 0, day: 19, month: 11, year: 2015, calendar: calendar)))
        
        //valid
        dates.append(NSDate(day: 4, month: 5, year: 2015, calendar: calendar))
        
        //saturday
        dates.append(NSDate(day: 20, month: 6, year: 2015, calendar: calendar))
        
        //sunday
        dates.append(NSDate(day: 21, month: 6, year: 2015, calendar: calendar))
        
        //holiday easter monday
        dates.append(NSDate(day: 6, month: 4, year: 2015, calendar: calendar))
    }
    
    
    override func tearDown()
    {
        sessionDAO.removeSessions(project)
        projectDAO.removeProject(project)
        sessions.removeAll(keepCapacity: false)
        dates.removeAll(keepCapacity: false)
        
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
    
    
    func testAddSession_SessionStartExceedsFinalDate_SessionIsNotAdded()
    {
        var pass = sessionManager.addSession(self.sessions[4], project: project)
        
        let sessions = sessionDAO.getSessions(project)
        if sessions.count == 0
        {
            pass = !pass
        }
        else
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testAddSession_SessionEndExceedsFinalDate_SessionIsNotAdded()
    {
        var pass = sessionManager.addSession(self.sessions[5], project: project)
        
        let sessions = sessionDAO.getSessions(project)
        if sessions.count == 0
        {
            pass = !pass
        }
        else
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testIsEmptySessionDay_DayIsValid_DayIsEmpty()
    {
        var pass = sessionManager.isEmptySessionDay(dates[0])
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testIsEmptySessionDay_DayIsValidButSessionsHasBeenRecorded_DayIsNotEmpty()
    {
        sessionManager.addSession(sessions[0], project: project)
        var pass = sessionManager.isEmptySessionDay(dates[0])
        
        XCTAssert(!pass, "Pass")
    }
    
    
    func testIsEmptySessionDay_DayIsSaturday_DayIsNotEmpty()
    {
        var pass = sessionManager.isEmptySessionDay(dates[1])
        
        XCTAssert(!pass, "Pass")
    }
    
    
    func testIsEmptySessionDay_DayIsSunday_DayIsNotEmpty()
    {
        var pass = sessionManager.isEmptySessionDay(dates[2])
        
        XCTAssert(!pass, "Pass")
    }
    
    
    func testIsEmptySessionDay_DayIsHoliday_DayIsNotEmpty()
    {
        var pass = sessionManager.isEmptySessionDay(dates[3])
        
        XCTAssert(!pass, "Pass")
    }
}

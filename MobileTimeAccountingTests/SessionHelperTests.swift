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
class SessionHelperTests: XCTestCase
{
    let calendar = NSCalendar.currentCalendar()
    let sessionHelper = SessionHelper()
    
    let project = Project(id: "12345", name: "Test Project 1")
    var sessions = [Session]()
    
    
    override func setUp()
    {
        projectDAO.addProject(project)
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 12, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 12, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 18, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 7, minute: 30, second: 0, day: 5, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 12, minute: 30, second: 0, day: 5, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 14, minute: 0, second: 0, day: 5, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 5, month: 5, year: 2015, calendar: calendar)))
        
        for session in sessions
        {
            sessionDAO.addSession(session, project: project)
        }
        
        super.setUp()
    }
    
    
    override func tearDown()
    {
        sessionDAO.removeSessions(project)
        projectDAO.removeProject(project)
        
        super.tearDown()
    }

    
    func testCalculateRemainingSessionTimeLeftForADay_DayAlreadyFull_NoSessionTimeLeft()
    {
        let remainingTime = sessionHelper.calculateRemainingSessionTimeLeftForADay(NSDate(day: 4, month: 5, year: 2015, calendar: calendar))
        XCTAssert(remainingTime == 0, "Pass")
    }
    
    
    func testCalculateRemainingSessionTimeLeftForADay_DayAlmostFullSessionDoesExceed_RemainingSessionTimeLeft()
    {
        let remainingTime = sessionHelper.calculateRemainingSessionTimeLeftForADay(NSDate(day: 5, month: 5, year: 2015, calendar: calendar))
        XCTAssert(remainingTime == 3, "Pass")
    }
}

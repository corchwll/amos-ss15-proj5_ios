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
class SessionValidatorTests: XCTestCase
{
    let calendar = NSCalendar.currentCalendar()
    let project = Project(id: "10001", name: "Test Project 1", finalDate: NSDate(day: 25, month: 6, year: 2015, calendar: NSCalendar.currentCalendar()), latitude: nil, longitude: nil)
    var sessions = [Session]()
    let sessionValidator = SessionValidator()
    
    
    override func setUp()
    {
        super.setUp()
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 25, month: 6, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 25, month: 6, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 22, minute: 0, second: 0, day: 25, month: 6, year: 2015, calendar: calendar), endTime: NSDate(hour: 5, minute: 0, second: 0, day: 26, month: 6, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 26, month: 6, year: 2015, calendar: calendar), endTime: NSDate(hour: 16, minute: 0, second: 0, day: 26, month: 6, year: 2015, calendar: calendar)))
    }
    
    
    override func tearDown()
    {
        sessions.removeAll(keepCapacity: false)
        
        super.tearDown()
    }
    
    
    func testIsExceedingFinalDate_SessionEndBeforeFinalDate_SessionDoesNotExccedFinalDate()
    {
        var pass = sessionValidator.isExceedingFinalDate(sessions[0], project: project)
        XCTAssert(!pass, "Pass")
    }

    
    func testIsExceedingFinalDate_SessionEndAfterFinalDate_SessionDoesNotExccedFinalDate()
    {
        var pass = sessionValidator.isExceedingFinalDate(sessions[1], project: project)
        XCTAssert(pass, "Pass")
    }
    
    
    func testIsExceedingFinalDate_SessionStartAfterFinalDate_SessionDoesNotExccedFinalDate()
    {
        var pass = sessionValidator.isExceedingFinalDate(sessions[2], project: project)
        XCTAssert(pass, "Pass")
    }
    
}

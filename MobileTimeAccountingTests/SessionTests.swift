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
class SessionTests: XCTestCase
{
    let calendar = NSCalendar.currentCalendar()
    var sessions = [Session]()
    
    
    override func setUp()
    {
        super.setUp()
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 12, minute: 0, second: 0, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 5, minute: 30, second: 4, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 10, minute: 24, second: 50, day: 4, month: 5, year: 2015, calendar: calendar)))
        
        sessions.append(Session(id: 0, startTime: NSDate(hour: 9, minute: 59, second: 59, day: 4, month: 5, year: 2015, calendar: calendar), endTime: NSDate(hour: 12, minute: 1, second: 1, day: 4, month: 5, year: 2015, calendar: calendar)))
    }
 
    
    override func tearDown()
    {
        super.tearDown()
    }

    
    func testGetDurationInSeconds_MultipleSessions_DurationIsReturned()
    {
        var pass = true
        
        pass = pass || sessions[0].getDurationInSeconds() == 14400
        pass = pass || sessions[0].getDurationInSeconds() == 17686
        pass = pass || sessions[0].getDurationInSeconds() == 7262
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testSessionByDecreasingEndTime_MultipleSessionValidTimeInterval_SessionEndTimeDecreased()
    {
        var pass = true
        let session1 = sessions[0].sessionByDecreasingEndTime(150)
        let session2 = sessions[0].sessionByDecreasingEndTime(12201)
        let session3 = sessions[0].sessionByDecreasingEndTime(4023)
        
        pass = pass || session1.getDurationInSeconds() == 14400 - 150
        pass = pass || session2.getDurationInSeconds() == 17686 - 12201
        pass = pass || session3.getDurationInSeconds() == 7262 - 4023
        
        XCTAssert(pass, "Pass")
    }
}

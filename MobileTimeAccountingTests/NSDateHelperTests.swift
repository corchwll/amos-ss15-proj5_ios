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

import XCTest


class NSDateHelperTests: XCTestCase
{
    let calendar = NSCalendar.currentCalendar()
    var date = NSDate(month: 6, year: 2015, calendar: NSCalendar.currentCalendar())
    
    
    override func setUp()
    {
        super.setUp()
    }
    
    
    override func tearDown()
    {
        super.tearDown()
    }

    
    func testStartOfMonth()
    {
        var startOfMonthComponents = NSDateComponents()
        startOfMonthComponents.hour = 0
        startOfMonthComponents.minute = 0
        startOfMonthComponents.second = 0
        startOfMonthComponents.day = 1
        startOfMonthComponents.month = 6
        startOfMonthComponents.year = 2015
        let startOfMonth = calendar.dateFromComponents(startOfMonthComponents)!

        XCTAssert(startOfMonth.timeIntervalSince1970 == date.startOfMonth()!.timeIntervalSince1970, "Pass")
    }
    
    
    func testEndOfMonth()
    {
        var endOfMonthComponents = NSDateComponents()
        endOfMonthComponents.hour = 23
        endOfMonthComponents.minute = 59
        endOfMonthComponents.second = 59
        endOfMonthComponents.day = 30
        endOfMonthComponents.month = 6
        endOfMonthComponents.year = 2015
        let endOfMonth = calendar.dateFromComponents(endOfMonthComponents)!
        
        XCTAssert(endOfMonth.timeIntervalSince1970 == date.endOfMonth()!.timeIntervalSince1970, "Pass")
    }
}

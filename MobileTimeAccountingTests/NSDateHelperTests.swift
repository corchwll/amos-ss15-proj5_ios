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

/*
    Naming convention for all tests: 'UnitOfWork_StateUnderTest_ExpectedBehavior'
*/
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

    
    func testStartOfMonth_DateInitialized_StartOfMonthReturned()
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
    
    
    func testEndOfMonth_DateInitialized_EndOfMonthReturned()
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
    
    
    func testDateByAddinMonths_MonthsAdded_DateIncrementedByAmountOfMonths()
    {
        let incrementedDate = date.dateByAddingMonths(2)
        
        XCTAssert(incrementedDate == NSDate(month: 8, year: 2015, calendar: calendar), "Pass")
    }
    
    
    func testDateByAddinMonths_MoreMonthsThanInYearAdded_DateIncrementedByAmountOfMonths()
    {
        let incrementedDate = date.dateByAddingMonths(14)
        
        XCTAssert(incrementedDate == NSDate(month: 8, year: 2016, calendar: calendar), "Pass")
    }
    
    
    func testDateByAddingDays_DaysAdded_DateIcrementedByAmountOfDays()
    {
        let incrementedDate = date.dateByAddingDays(20)
        
        XCTAssert(incrementedDate == NSDate(day: 21, month: 6, year: 2015, calendar: calendar), "Pass")
    }
    
    
    func testDateByAddingDays_MoreDaysThanInMonthAdded_DateIcrementedByAmountOfDays()
    {
        let incrementedDate = date.dateByAddingDays(40)
        
        XCTAssert(incrementedDate == NSDate(day: 11, month: 7, year: 2015, calendar: calendar), "Pass")
    }
}

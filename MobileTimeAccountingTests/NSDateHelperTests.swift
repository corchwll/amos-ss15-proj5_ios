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
    var day = NSDate(hour: 14, minute: 30, second: 23, day: 2, month: 4, year: 2015, calendar: NSCalendar.currentCalendar())
    
    
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
    
    
    func testStartOfDay_DateIsValid_StartOfDayReturned()
    {
        var startOfDayComponents = NSDateComponents()
        startOfDayComponents.hour = 0
        startOfDayComponents.minute = 0
        startOfDayComponents.second = 0
        startOfDayComponents.day = 2
        startOfDayComponents.month = 4
        startOfDayComponents.year = 2015
        let startOfDay = calendar.dateFromComponents(startOfDayComponents)!
        
        XCTAssert(startOfDay.timeIntervalSince1970 == day.startOfDay()!.timeIntervalSince1970, "Pass")
    }

    
    func testEndOfDay_DateIsValid_EndOfDayReturned()
    {
        var endOfDayComponents = NSDateComponents()
        endOfDayComponents.hour = 23
        endOfDayComponents.minute = 59
        endOfDayComponents.second = 59
        endOfDayComponents.day = 2
        endOfDayComponents.month = 4
        endOfDayComponents.year = 2015
        let endOfDay = calendar.dateFromComponents(endOfDayComponents)!
        
        XCTAssert(endOfDay.timeIntervalSince1970 == day.endOfDay()!.timeIntervalSince1970, "Pass")
    }
    
    
    func testIsHoliday_DateIsOnEasterMonday_DateIsHoliday()
    {
        let date = NSDate(day: 6, month: 4, year: 2015, calendar: calendar)
        
        XCTAssert(date.isHoliday(), "Pass")
    }
    
    
    func testIsHoliday_DateIsOnACommonSaturday_DateIsNoHoliday()
    {
        let date = NSDate(day: 11, month: 4, year: 2015, calendar: calendar)
        
        XCTAssert(!date.isHoliday(), "Pass")
    }
    
    
    func testIsSaturday_DateIsOnASaturday_DateIsSaturday()
    {
        let date = NSDate(day: 11, month: 4, year: 2015, calendar: calendar)
        
        XCTAssert(date.isSaturday(), "Pass")
    }
    
    
    func testIsSaturday_DateIsOnEasterMonday_DateIsNoSaturday()
    {
        let date = NSDate(day: 6, month: 4, year: 2015, calendar: calendar)
        
        XCTAssert(!date.isSaturday(), "Pass")
    }
    
    
    func testIsSunday_DateIsOnASunday_DateIsSunday()
    {
        let date = NSDate(day: 26, month: 4, year: 2015, calendar: calendar)
        
        XCTAssert(date.isSunday(), "Pass")
    }
    
    
    func testIsSunday_DateIsOnASaturday_DateIsNoSunday()
    {
        let date = NSDate(day: 11, month: 4, year: 2015, calendar: calendar)
        
        XCTAssert(!date.isSunday(), "Pass")
    }
}

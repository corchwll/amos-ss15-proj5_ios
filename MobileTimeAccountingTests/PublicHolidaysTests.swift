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
class PublicHolidaysTests: XCTestCase
{
    var publicHolidaysOf2015 =
    [
        (day: 1, month: 1, year: 2015), //New Year's Day
        (day: 6, month: 1, year: 2015), //Epiphany
        (day: 1, month: 5, year: 2015), //May Day
        (day: 15, month: 8, year: 2015), //Maria Himmelfahrt
        (day: 3, month: 10, year: 2015), //Day of German Unity
        (day: 1, month: 11, year: 2015), //All Saint's Day
        (day: 25, month: 12, year: 2015), //Christmas Day
        (day: 26, month: 12, year: 2015), //Boxing Day
        (day: 3, month: 4, year: 2015), //Good Friday
        (day: 6, month: 4, year: 2015), //Easter Monday
        (day: 14, month: 5, year: 2015), //Ascension Day
        (day: 25, month: 5, year: 2015), //Whit Monday
        (day: 4, month: 6, year: 2015)  //Corpus Christi
    ]
    
    
    override func setUp()
    {
        super.setUp()
    }
    
    
    override func tearDown()
    {
        super.tearDown()
    }

    
    func testCalculatePublicHolidaysForYear_ValidYearIsGiven_CalculateAllPublicHolidaysDates()
    {
        let year = 2015
        let publicHolidays = PublicHolidays().calculatePublicHolidaysForYear(year)
        
        var publicHolidayDatesOf2015 = [NSDate]()
        for publicHolidayOf2015 in publicHolidaysOf2015
        {
            var publicHoliday = NSDateComponents()
            publicHoliday.day = publicHolidayOf2015.day
            publicHoliday.month = publicHolidayOf2015.month
            publicHoliday.year = publicHolidayOf2015.year
            publicHolidayDatesOf2015.append(NSCalendar.currentCalendar().dateFromComponents(publicHoliday)!)
        }

        var pass = true
        for publicHoliday in publicHolidays
        {
            var hasElement = false
            for publicHolidayDateOf2014 in publicHolidayDatesOf2015
            {
                if publicHoliday.timeIntervalSince1970 == publicHolidayDateOf2014.timeIntervalSince1970
                {
                    hasElement = true
                }
            }
            pass = pass && hasElement
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testCalculatePublicHolidaysInDays_ValidRangeIsGiven_CalculateValidCountOfPublicHolidays()
    {
        var startDay = NSDateComponents()
        startDay.day = 8
        startDay.month = 4
        startDay.year = 2015
        
        var endDay = NSDateComponents()
        endDay.day = 9
        endDay.month = 10
        endDay.year = 2015
    
        let publicHolidayCount = PublicHolidays().calculatePublicHolidaysInDays(NSCalendar.currentCalendar().dateFromComponents(startDay)!, endDate: NSCalendar.currentCalendar().dateFromComponents(endDay)!)
        
        XCTAssert(publicHolidayCount == 6, "Pass")
    }
}

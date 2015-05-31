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

import Foundation


class PublicHolidays
{
    let calendar = NSCalendar.currentCalendar()
    
    
    func calculatePublicHolidaysInDays(startDate: NSDate, endDate: NSDate)->Int
    {
        let startDateComponents = calendar.components(.CalendarUnitYear, fromDate: startDate)
        let endDateComponents = calendar.components(.CalendarUnitYear, fromDate: endDate)
        
        var publicHolidays = [NSDate]()
        for year in startDateComponents.year...endDateComponents.year
        {
            publicHolidays += calculatePublicHolidaysForYear(year)
        }
        
        var publicHolidaysCount = 0
        for publicHoliday in publicHolidays
        {
            if startDate.timeIntervalSince1970 <= publicHoliday.timeIntervalSince1970 && endDate.timeIntervalSince1970 >= publicHoliday.timeIntervalSince1970
            {
                publicHolidaysCount++
            }
        }
        return publicHolidaysCount
    }
    
    
    func calculatePublicHolidaysForYear(year: Int)->[NSDate]
    {
        var publicHolidays = [NSDate]()
 
        //New Year's Day
        var newYearsDay = NSDateComponents()
        newYearsDay.day = 1
        newYearsDay.month = 1
        newYearsDay.year = year
        publicHolidays.append(calendar.dateFromComponents(newYearsDay)!)
        
        //Epiphany
        var epiphany = NSDateComponents()
        epiphany.day = 6
        epiphany.month = 1
        epiphany.year = year
        publicHolidays.append(calendar.dateFromComponents(epiphany)!)
    
        //May Day
        var mayDay = NSDateComponents()
        mayDay.day = 1
        mayDay.month = 5
        mayDay.year = year
        publicHolidays.append(calendar.dateFromComponents(mayDay)!)

        //Mariä Himmelfahrt
        var mariäHimmelfahrt = NSDateComponents()
        mariäHimmelfahrt.day = 15
        mariäHimmelfahrt.month = 8
        mariäHimmelfahrt.year = year
        publicHolidays.append(calendar.dateFromComponents(mariäHimmelfahrt)!)
        
        //Day of German Unity
        var dayOfGermanUnity = NSDateComponents()
        dayOfGermanUnity.day = 3
        dayOfGermanUnity.month = 10
        dayOfGermanUnity.year = year
        publicHolidays.append(calendar.dateFromComponents(dayOfGermanUnity)!)
        
        //All Saint's Day
        var allSaintsDay = NSDateComponents()
        allSaintsDay.day = 1
        allSaintsDay.month = 11
        allSaintsDay.year = year
        publicHolidays.append(calendar.dateFromComponents(allSaintsDay)!)
        
        //Christmas Day
        var christmasDay = NSDateComponents()
        christmasDay.day = 25
        christmasDay.month = 12
        christmasDay.year = year
        publicHolidays.append(calendar.dateFromComponents(christmasDay)!)
        
        //Boxing Day
        var boxingDay = NSDateComponents()
        boxingDay.day = 26
        boxingDay.month = 12
        boxingDay.year = year
        publicHolidays.append(calendar.dateFromComponents(boxingDay)!)
      
        
        var eastern = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: calculateEastern(year))
        
        //Good Friday
        eastern.day -= 2
        let goodFriday = calendar.dateFromComponents(eastern)!
        publicHolidays.append(goodFriday)
        
        //Easter Monday
        eastern.day += 3
        let easterMonday = calendar.dateFromComponents(eastern)!
        publicHolidays.append(easterMonday)
        
        //Ascension Day
        eastern.day += 38
        let ascensionDay = calendar.dateFromComponents(eastern)!
        publicHolidays.append(ascensionDay)
        
        //Whit Monday
        eastern.day += 11
        let whitMonday = calendar.dateFromComponents(eastern)!
        publicHolidays.append(whitMonday)
        
        //Corpus Christi
        eastern.day += 10
        let corpusChristi = calendar.dateFromComponents(eastern)!
        publicHolidays.append(corpusChristi)
        
        
        return publicHolidays
    }
    
    
    private func calculateEastern(year: Int)->NSDate
    {
        let a = year % 19;
        let b = year % 4;
        let c = year % 7;
        let k = year/100;
        let p = (8*k + 13)/25;
        let q = k/4;
        let M = (15 + k - p - q) % 30;
        let d = (19*a + M) % 30;
        let N = (4 + k - q) % 7;
        let e = (2*b + 4*c + 6*d + N) % 7;
        let o = 22 + d + e;
        
        var eastern = NSDateComponents()
        eastern.day = o % 31;
        eastern.month = o > 31 ? 4 : 3
        eastern.year = year
        
        return calendar.dateFromComponents(eastern)!
    }
}
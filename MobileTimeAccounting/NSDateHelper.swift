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


extension NSDate
{
    convenience init(month: Int, year: Int, calendar: NSCalendar)
    {
        var date = NSDateComponents()
        date.month = month
        date.year = year
        self.init(timeIntervalSince1970: calendar.dateFromComponents(date)!.timeIntervalSince1970)
    }
    
    
    convenience init(day: Int, month: Int, year: Int, calendar: NSCalendar)
    {
        var date = NSDateComponents()
        date.day = day
        date.month = month
        date.year = year
        self.init(timeIntervalSince1970: calendar.dateFromComponents(date)!.timeIntervalSince1970)
    }
    
    
    convenience init(hour: Int, minute: Int, second: Int, day: Int, month: Int, year: Int, calendar: NSCalendar)
    {
        var date = NSDateComponents()
        date.hour = hour
        date.minute = minute
        date.second = second
        date.day = day
        date.month = month
        date.year = year
        self.init(timeIntervalSince1970: calendar.dateFromComponents(date)!.timeIntervalSince1970)
    }

    
    func startOfMonth() -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        let currentDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: self)
        let startOfMonth = calendar.dateFromComponents(currentDateComponents)
        
        return startOfMonth
    }
    
    
    func endOfMonth() -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        if let plusOneMonthDate = dateByAddingMonths(1)
        {
            let plusOneMonthDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: plusOneMonthDate)
            
            let endOfMonth = calendar.dateFromComponents(plusOneMonthDateComponents)?.dateByAddingTimeInterval(-1)
            
            return endOfMonth
        }
        
        return nil
    }
    
    
    func dateByAddingMonths(monthsToAdd: Int) -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        let months = NSDateComponents()
        months.month = monthsToAdd
        
        return calendar.dateByAddingComponents(months, toDate: self, options: nil)
    }
    
    
    func dateByAddingDays(daysToAdd: Int) -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        let days = NSDateComponents()
        days.day = daysToAdd
        
        return calendar.dateByAddingComponents(days, toDate: self, options: nil)
    }
}
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
    /*
        Constructor for initializing dates only by setting month and year.
        
        @methodtype Constructor
        @pre Valid calendar
        @post Initializes date for given month and year
    */
    convenience init(month: Int, year: Int, calendar: NSCalendar)
    {
        var date = NSDateComponents()
        date.month = month
        date.year = year
        self.init(timeIntervalSince1970: calendar.dateFromComponents(date)!.timeIntervalSince1970)
    }
    
    
    /*
        Constructor for initializing dates only by setting day, month and year.
        
        @methodtype Constructor
        @pre Valid calendar
        @post Initializes date for given day, month and year
    */
    convenience init(day: Int, month: Int, year: Int, calendar: NSCalendar)
    {
        var date = NSDateComponents()
        date.day = day
        date.month = month
        date.year = year
        self.init(timeIntervalSince1970: calendar.dateFromComponents(date)!.timeIntervalSince1970)
    }
    
    
    /*
        Constructor for initializing dates by setting hour, minute, second, day, month and year.
        
        @methodtype Constructor
        @pre Valid calendar
        @post Initializes date for given hour, minute, second, day, month and year
    */
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

    
    /*
        Returns start date of the current month.
        
        @methodtype Helper
        @pre -
        @post Returns start of month
    */
    func startOfMonth() -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        let currentDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: self)
        let startOfMonth = calendar.dateFromComponents(currentDateComponents)
        
        return startOfMonth
    }
    
    
    /*
        Returns end date of the current month.
        
        @methodtype Helper
        @pre -
        @post Returns end of month
    */
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
    
    
    /*
        Returns start day of the current day.
        
        @methodtype Helper
        @pre -
        @post Returns start of month
    */
    func startOfDay() -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        let currentDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitYear | .CalendarUnitMonth, fromDate: self)
        let startOfDay = calendar.dateFromComponents(currentDateComponents)
        
        return startOfDay
    }
    
    
    /*
        Returns end of day of the current day.
        
        @methodtype Helper
        @pre -
        @post Returns end of month
    */
    func endOfDay() -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        if let plusOneDayDate = dateByAddingDays(1)
        {
            let plusOneDayDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitYear | .CalendarUnitMonth, fromDate: plusOneDayDate)
            let endOfDay = calendar.dateFromComponents(plusOneDayDateComponents)?.dateByAddingTimeInterval(-1)
            
            return endOfDay
        }
        return nil
    }
    
    
    /*
        Returns date after adding an amount of months
        
        @methodtype Helper
        @pre Month must be a value between 1 and 12
        @post Returns date after adding months
    */
    func dateByAddingMonths(monthsToAdd: Int) -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        let months = NSDateComponents()
        months.month = monthsToAdd
        
        return calendar.dateByAddingComponents(months, toDate: self, options: nil)
    }
    
    
    /*
        Returns date after adding an amount of days
    
        @methodtype Helper
        @pre Days must be a valid value (>0)
        @post Returns date after adding days
    */
    func dateByAddingDays(daysToAdd: Int) -> NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        let days = NSDateComponents()
        days.day = daysToAdd
        
        return calendar.dateByAddingComponents(days, toDate: self, options: nil)
    }
    
    
    /*
        Returns date after setting time (hours,minutes,seconds).
    
        @methodtype Helper
        @pre Valid time paramters
        @post Returns date after setting time
    */
    func dateBySettingTime(hour: Int, minute: Int, second: Int)->NSDate?
    {
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateBySettingHour(hour, minute: minute, second: second, ofDate: self, options: nil)
    }
    
    
    
    /*
        Returns weekday of the current date.
        
        @methodtype Helper
        @pre -
        @post Returns weekday
    */
    func weekday()->Int
    {
        let calendar = NSCalendar.currentCalendar()
        let weekDayDateComponent = calendar.components(.CalendarUnitWeekday, fromDate: self)
        return weekDayDateComponent.weekday
    }
}
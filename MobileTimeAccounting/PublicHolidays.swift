//
//  PublicHolidays.swift
//  MobileTimeAccounting
//
//  Created by cdan on 28/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation


class PublicHolidays
{
    let calendar = NSCalendar.currentCalendar()
    
    
    func calculatePublicHolidaysInDays(startDate: NSDate, endDate: NSDate)->Int
    {
        let startDateComponents = calendar.components(.CalendarUnitTimeZone | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: startDate)
        let endDateComponents = calendar.components(.CalendarUnitTimeZone | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: endDate)
        
        let startYear = startDateComponents.year
        let endYear = endDateComponents.year
        
        for year in startYear...endYear
        {
            calculatePublicHolidaysForYear(year)
        }
        return 0
    }
    
    
    private func calculatePublicHolidaysForYear(year: Int)
    {
        //todo: calc holidays
    }
}
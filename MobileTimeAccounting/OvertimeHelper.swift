//
//  OvertimeHelper.swift
//  MobileTimeAccounting
//
//  Created by cdan on 28/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation


let overtimeHelper = OvertimeHelper()


class OvertimeHelper
{
    let calendar = NSCalendar.currentCalendar()
    var holidaysPerYear = [[NSDate]]()
    var sessions = [Session]()
    
    
    func getCurrentOvertime()->Int
    {
        loadAllSessions()
        calculatePublicHolidaysPerYear()
            
        return 0
    }
    
    
    private func loadAllSessions()
    {
        sessions = sessionDAO.getSessions(Project(id: "00004", name: "", finalDate: NSDate()))
    }
    
    
    private func calculatePublicHolidaysPerYear()
    {
        let startDate = sessions.first!.startTime
        let endDate = sessions.last!.endTime
        
        let startDateComponents = calendar.components(.CalendarUnitTimeZone | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: startDate)
        let endDateComponents = calendar.components(.CalendarUnitTimeZone | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: endDate)
        
        let startYear = startDateComponents.year
        let endYear = endDateComponents.year
        
        for year in startYear...endYear
        {
            calculatePublicHolidaysForYear(year)
        }
    }
    
    
    private func calculatePublicHolidaysForYear(year: Int)
    {
        //todo: calc holidays
    }
    
    
    private func calculateCurrentWorkingTimeInSeconds()->Int
    {
        var workingTimeInSeconds = 0
        for session in sessions
        {
            workingTimeInSeconds += (Int(session.endTime.timeIntervalSince1970 - session.startTime.timeIntervalSince1970))
        }
        return workingTimeInSeconds
    }
    
    
    private func calculateCurrentWorkingTimeDebtInDays()->Int
    {
        let weeklyWorkingTime = profileDAO.getProfile()?.weeklyWorkingTime?.toInt()
        
        let startDate = sessions.last!.startTime
        let endDate = sessions.first!.endTime
        
        var startDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: startDate)
        var endDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: endDate)
        
        var workingTimeDebtInDays = 0
        while (startDateComponents.day != endDateComponents.day || startDateComponents.month != endDateComponents.month || startDateComponents.year != endDateComponents.year)
        {
            if startDateComponents.weekday != 1 && startDateComponents.weekday != 7
            {
                workingTimeDebtInDays += 1
            }
            startDateComponents.day += 1
            startDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: calendar.dateFromComponents(startDateComponents)!)
        }
        return workingTimeDebtInDays
    }
}
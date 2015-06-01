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


let overtimeHelper = OvertimeHelper()


class OvertimeHelper
{
    let calendar = NSCalendar.currentCalendar()
    var holidaysPerYear = [[NSDate]]()
    var sessions = [Session]()
    
    
    func getCurrentOvertime()->Int
    {
        loadAllSessions()
        let currentWorkingTime = calculateCurrentWorkingTime()
        let currentWorkingTimeDebt = calculateCurrentWorkingTimeDebt()
        
        return currentWorkingTime - currentWorkingTimeDebt
    }
    
    
    private func loadAllSessions()
    {
        sessions = sessionDAO.getAllSessions()
    }
    
    
    private func calculateCurrentWorkingTime()->Int
    {
        let currentWorkingTimeInSeconds = calculateCurrentWorkingTimeInSeconds()
        let currentWorkingTimeInHours = (Double(currentWorkingTimeInSeconds)) / 3600.0
        return (Int(currentWorkingTimeInHours))
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
    
    
    private func calculateCurrentWorkingTimeDebt()->Int
    {
        let currentWorkingTimeDebtInDays = calculateCurrentWorkingTimeDebtInDays()
        let dailyWorkingTime = (Double(profileDAO.getProfile()!.weeklyWorkingTime!.toInt()!)) / 5.0
        let currentWorkingTimeDebtInHours = (Double(currentWorkingTimeDebtInDays)) * dailyWorkingTime
        return (Int(currentWorkingTimeDebtInHours))
    }
    
    
    private func calculateCurrentWorkingTimeDebtInDays()->Int
    {
        let weeklyWorkingTime = profileDAO.getProfile()?.weeklyWorkingTime?.toInt()
        var workingTimeDebtInDays = 0
        
        if !sessions.isEmpty
        {
            let startDate = sessions.last!.startTime
            let endDate = sessions.first!.endTime
            
            var startDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: startDate)
            var endDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: endDate)
            
            
            while(startDateComponents.day <= endDateComponents.day || startDateComponents.month < endDateComponents.month || startDateComponents.year < endDateComponents.year)
            {
                if startDateComponents.weekday != 1 && startDateComponents.weekday != 7
                {
                    workingTimeDebtInDays += 1
                }
                startDateComponents.day += 1
                startDateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitWeekday, fromDate: calendar.dateFromComponents(startDateComponents)!)
            }
        }
        
        return workingTimeDebtInDays
    }
}
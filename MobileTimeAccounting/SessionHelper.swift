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


class SessionHelper
{
    /*
        Returns remaining session time in hours for a given day. If there are already sessions stored and the total duration of all sessions in that day exceeds 10 hours, 0 is returned.
        Else the remaining time until 10 hours are reached is returned.
        
        @methodtype Boolean Query
        @pre Session start time before end time
        @post Returns if session is valid
    */
    func calculateRemainingSessionTimeLeftForADay(day: NSDate)->Int
    {
        let currentSessionsDurationInHours = calculateAccumulatedSessionsDurationInMinutesForADay(day) / 60
        
        if currentSessionsDurationInHours > 10
        {
            return 0
        }
        else
        {
            return 10 - currentSessionsDurationInHours
        }
    }
    
    
    /*
        Returns accumulated sessions duration in minutes for a given day. All session concerning the given day are accumulated, but only times lying in that day are taken.
        If a session exceeds the given day, time is cut off at the exceedance point.
        
        @methodtype Helper
        @pre -
        @post Returns accumulated sessions duration in minutes for a given day
    */
    private func calculateAccumulatedSessionsDurationInMinutesForADay(day: NSDate)->Int
    {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: day)
        
        let startTime = NSDate(hour: 0, minute: 0, second: 0, day: dateComponents.day, month: dateComponents.month, year: dateComponents.year, calendar: calendar)
        let endTime = NSDate(hour: 23, minute: 59, second: 59, day: dateComponents.day, month: dateComponents.month, year: dateComponents.year, calendar: calendar)
        
        var durationInSeconds = 0
        for session in sessionDAO.getSessions(startTime, toTime: endTime)
        {
            durationInSeconds += getSessionDurationInTimeSpan(session, startTime: startTime, endTime: endTime)
        }
        
        return durationInSeconds/60
    }
    
    
    /*
        Returns session duration in seconds of a given time span. A session can lie in between the given time span,
        it can exceed the given start or end time and it can cover the complete time span from start to end time.
        Nevertheless only the duration in between the given start and end is counted.
        
        @methodtype Helper
        @pre Start time before end time
        @post Returns session duration in a given time span
    */
    private func getSessionDurationInTimeSpan(session: Session, startTime: NSDate, endTime: NSDate)->Int
    {
        let sessionStartInterval = session.startTime.timeIntervalSince1970
        let sessionEndInterval = session.endTime.timeIntervalSince1970
        
        let startInterval = startTime.timeIntervalSince1970
        let endInterval = endTime.timeIntervalSince1970
        
        var duration = 0
        
        if sessionStartInterval >= startInterval && sessionEndInterval <= endInterval
        {
            duration = Int(sessionEndInterval) - Int(sessionStartInterval)
        }
        else if sessionStartInterval <= startInterval && sessionEndInterval >= endInterval
        {
            duration = Int(endInterval) - Int(startInterval)
        }
        else if sessionStartInterval >= startInterval && sessionEndInterval >= endInterval
        {
            duration = Int(endInterval) - Int(sessionStartInterval)
        }
        else if sessionStartInterval <= startInterval && sessionEndInterval <= endInterval
        {
            duration = Int(sessionEndInterval) - Int(startInterval)
        }
        
        return duration
    }
}
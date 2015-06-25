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


let sessionManager = SessionManager()


class SessionManager
{
    let OverlappingSessionMessage = "New session is overlapping with other session!"
    let ExceedingSessionMessage = "New session is exceeding project's final date!"
    let SessionOverflowMessage = "Session exceeds limit of 10 hour per day!"
    let SessionCutOffMessage = "Session exceeds 10 hours per day and was cut off!"
    
    let sessionHelper = SessionHelper()
    let sessionValidator = SessionValidator()
    
    
    /*
        Adds new session to the given project into database. Some validation tests verify if a session is valid and can be stored into database.
        
        @methodtype Command
        @pre Session is not overlapping
        @post Session is stored into database
    */
    func addSession(session: Session, project: Project)->Bool
    {
        if sessionValidator.isExceedingFinalDate(session, project: project)
        {
            showAlert(ExceedingSessionMessage)
            return false
        }
        
        if sessionValidator.isOverlappingSession(session)
        {
            showAlert(OverlappingSessionMessage)
            return false
        }
        
        return doAddSession(session, project: project)
    }
    
    
    /*
        Stores session for a given project into database. If the total session limit for a day is already reached, no session will be stored. 
        If there is some time left, a session is cut off at the end time and stored into database.
        
        @methodtype Command
        @pre Some session time left before daily limit is reached
        @post Session is stored into database
    */
    private func doAddSession(session: Session, project: Project)->Bool
    {
        let remainingSessionTimeInSeconds = SessionHelper().calculateRemainingSessionTimeLeftForADay(session.startTime)
        if remainingSessionTimeInSeconds == 0
        {
            showAlert(SessionOverflowMessage)
            return false
        }
        
        var exceedingSessionTimeInSeconds = 0
        let sessionDurationInSeconds = session.getDurationInSeconds()
        if sessionDurationInSeconds > remainingSessionTimeInSeconds
        {
            showAlert(SessionCutOffMessage)
            exceedingSessionTimeInSeconds = sessionDurationInSeconds - remainingSessionTimeInSeconds
        }
        
        sessionDAO.addSession(session.sessionByDecreasingEndTime(exceedingSessionTimeInSeconds), project: project)
        return true
    }
    
    
    /*
        Validated if the given day is empty, meaning that no session has been recorded for that day and the day is no holiday.
        
        @methodtype Boolean Query
        @pre SessionDAO needs to be initialized
        @post Return if day is empty
    */
    func isEmptySessionDay(day: NSDate)->Bool
    {
        let hasNoSessions = sessionDAO.getSessions(day.startOfDay()!, toTime: day.endOfDay()!).isEmpty
        let isNoHoliday = PublicHolidays().calculatePublicHolidaysInDays(day.startOfDay()!, endDate: day.endOfDay()!) == 0
        let isNoWeekendDay = day.weekday() != 7 && day.weekday() != 1
        
        return hasNoSessions && isNoHoliday && isNoWeekendDay
    }
}

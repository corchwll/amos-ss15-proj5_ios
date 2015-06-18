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
    let OVERLAPPING_SESSION_MESSAGE = "New session is overlapping with other session!"
    let SESSION_OVERFLOW_MESSAGE = "Session exceeds limit of 10 hour per day!"
    let SESSION_CUT_OFF_MESSAGE = "Session exceeds 10 hours per day and was cut off!"
    
    let sessionHelper = SessionHelper()
    
    
    /*
        Adds new session to the given project into database. Some validation tests verify if a session is valid and can be stored into database.
        
        @methodtype Command
        @pre Session is not overlapping
        @post Session is stored into database
    */
    func addSession(session: Session, project: Project)->Bool
    {
        if isOverlappingSession(session)
        {
            return false
        }
        return doAddSession(session, project: project)
    }
    
    
    /*
        Verifies if a session is overlapping with other sessions or not.
        
        @methodtype Boolean Query
        @pre No overlapping sessions
        @post Returns if session is overlapping
    */
    private func isOverlappingSession(session: Session)->Bool
    {
        if sessionDAO.getSessions(session.startTime, toTime: session.endTime).count != 0
        {
            showAlert(OVERLAPPING_SESSION_MESSAGE)
            return true
        }
        return false
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
            showAlert(SESSION_OVERFLOW_MESSAGE)
            return false
        }
        
        var exceedingSessionTimeInSeconds = 0
        let sessionDurationInSeconds = session.getDurationInSeconds()
        if sessionDurationInSeconds > remainingSessionTimeInSeconds
        {
            showAlert(SESSION_CUT_OFF_MESSAGE)
            exceedingSessionTimeInSeconds = sessionDurationInSeconds - remainingSessionTimeInSeconds
        }
        
        sessionDAO.addSession(session.sessionByDecreasingEndTime(exceedingSessionTimeInSeconds), project: project)
        return true
    }
}

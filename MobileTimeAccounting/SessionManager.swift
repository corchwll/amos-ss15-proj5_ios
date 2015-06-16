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
    
    
    func addSession(session: Session, project: Project)->Bool
    {
        if sessionDAO.getSessions(session.startTime, toTime: session.endTime).count != 0
        {
            showAlert(OVERLAPPING_SESSION_MESSAGE)
            return false
        }
        
        let remainingSessionTime = SessionHelper().calculateRemainingSessionTimeLeftForADay(session.startTime)
            
        if remainingSessionTime == 0
        {
            showAlert(SESSION_OVERFLOW_MESSAGE)
            return false
        }

        let sessionDuration = Int(session.endTime.timeIntervalSince1970) - Int(session.startTime.timeIntervalSince1970)
        let exceedingSessionTime = 0
        
        if sessionDuration > remainingSessionTime
        {
            showAlert(SESSION_CUT_OFF_MESSAGE)
            let exceedingSessionTime = sessionDuration - remainingSessionTime
            session.endTime = NSDate(timeIntervalSince1970: session.endTime.timeIntervalSince1970 - NSTimeInterval(exceedingSessionTime))
        }
        
        sessionDAO.addSession(session, project: project)
        return true
    }
}

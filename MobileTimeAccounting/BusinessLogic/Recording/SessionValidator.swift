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


class SessionValidator
{
    /*
        Verifies if a session is overlapping with other sessions or not.
        
        @methodtype Boolean Query
        @pre No overlapping sessions
        @post Returns if session is overlapping
    */
    func isOverlappingSession(session: Session)->Bool
    {
        if sessionDAO.getSessions(session.startTime, toTime: session.endTime).count != 0
        {
            return true
        }
        return false
    }
    
    
    /*
        Verifies if a session is exceeding a project's final date. If final date is 0, that means it is not set so false is returned.
        
        @methodtype Boolean Query
        @pre Session start before session end
        @post Returns if session is exceeding final date
    */
    func isExceedingFinalDate(session: Session, project: Project)->Bool
    {
        if project.finalDate.timeIntervalSince1970 != 0 &&
            session.endTime.timeIntervalSince1970 > project.finalDate.endOfDay()!.timeIntervalSince1970
        {
            return true
        }
        return false
    }
}

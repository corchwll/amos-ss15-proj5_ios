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
import SQLite


let sessionDAO = SessionDAO()


class SessionDAO
{
    let id = Expression<Int>("id")
    let projectId = Expression<String>("project_id")
    let startTime = Expression<Int>("timestamp_start")
    let endTime = Expression<Int>("timestamp_end")
    
    
    /*
        Adds new session into sqlite database, session id not necessary because of auto increment.
    
        @methodtype Command
        @pre Existing project (foreign-key relationship)
        @post Stored session
    */
    func addSession(session: Session, project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        var start = (Int(session.startTime.timeIntervalSince1970))
        var end = (Int(session.endTime.timeIntervalSince1970))

        if let insert = sessions.insert(projectId <- project.id, startTime <- start, endTime <- end){}
    }
    
    
    /*
        Returns every session from sqlite database.
    
        @methodtype Query
        @pre -
        @post Every session from database
    */
    func getSessions(project: Project)->[Session]
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        var queriedSessions: [Session] = []
        for sessionRow in sessions.filter(projectId == project.id).order(startTime.desc)
        {
            var session = Session(id: sessionRow[id], startTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[startTime])),
                endTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[endTime])))
            queriedSessions.append(session)
        }
        return queriedSessions
    }
    
    
    /*
        Removes all sessions from the given project.
        
        @methodtype Command
        @pre -
        @post All sessions have been removed from project
    */
    func removeSessions(project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        sessions.filter(projectId == project.id).delete()!
    }
}
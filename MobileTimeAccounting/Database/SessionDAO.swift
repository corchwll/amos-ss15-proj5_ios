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
    let startTime = Expression<Double>("timestamp_start")
    let endTime = Expression<Double>("timestamp_end")
    
    
    /*
        Adds new session into sqlite database, session id not necessary because of auto increment.
    
        @methodtype Command
        @pre Existing project (foreign-key relationship)
        @post Session has been stored
    */
    func addSession(session: Session, project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        var start = (Double(session.startTime.timeIntervalSince1970))
        var end = (Double(session.endTime.timeIntervalSince1970))

        if let insert = sessions.insert(projectId <- project.id, startTime <- start, endTime <- end){}
    }
    
    
    /*
        Returns every session of given project from sqlite database.
    
        @methodtype Query
        @pre Project must exist
        @post Every session of given project has been returned
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
        Returns every session of given project in a given month from sqlite database.
        
        @methodtype Query
        @pre Project must exist
        @post Every session of given project has been returned
    */
    func getSessions(project: Project, month: Int, year: Int)->[Session]
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        var queriedSessions: [Session] = []
        let startOfMonth = NSDate(month: month, year: year, calendar: NSCalendar.currentCalendar()).startOfMonth()!
        let endOfMonth = NSDate(month: month, year: year, calendar: NSCalendar.currentCalendar()).endOfMonth()!
        
        for sessionRow in sessions.filter(projectId == project.id && startTime >= (Double(startOfMonth.timeIntervalSince1970)) && endTime <= (Double(endOfMonth.timeIntervalSince1970))).order(startTime.asc)
        {
            var session = Session(id: sessionRow[id], startTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[startTime])),
                endTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[endTime])))
            queriedSessions.append(session)
        }
        return queriedSessions
    }
    
    
    /*
        Returns every session of all prjoects from sqlite database in a given time range.
        
        @methodtype Query
        @pre -
        @post Every session is returned
    */
    func getSessions(fromTime: NSDate, toTime: NSDate)->[Session]
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        let fromTimeSince1970 = Double(fromTime.timeIntervalSince1970)
        let toTimeSince1970 = Double(toTime.timeIntervalSince1970)
        
        var queriedSessions: [Session] = []
        for sessionRow in sessions.filter(!(startTime <= fromTimeSince1970 && endTime <= fromTimeSince1970) && !(startTime >= toTimeSince1970 && endTime >= toTimeSince1970))
        {
            var session = Session(id: sessionRow[id], startTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[startTime])),
                endTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[endTime])))
            queriedSessions.append(session)
        }
        return queriedSessions
    }
    
    
    
    /*
        Returns every session of a given project from sqlite database in a given time range.
        
        @methodtype Query
        @pre -
        @post Every session is returned
    */
    func getSessions(fromTime: NSDate, toTime: NSDate, project: Project)->[Session]
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        let fromTimeSince1970 = Double(fromTime.timeIntervalSince1970)
        let toTimeSince1970 = Double(toTime.timeIntervalSince1970)
        
        var queriedSessions: [Session] = []
        for sessionRow in sessions.filter(projectId == project.id && !(startTime <= fromTimeSince1970 && endTime <= fromTimeSince1970) && !(startTime >= toTimeSince1970 && endTime >= toTimeSince1970))
        {
            var session = Session(id: sessionRow[id], startTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[startTime])),
                endTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[endTime])))
            queriedSessions.append(session)
        }
        return queriedSessions
    }
    
    
    
    /*
        Returns every session of all prjoects from sqlite database.
        
        @methodtype Query
        @pre -
        @post Every session has been returned
    */
    func getAllSessions()->[Session]
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        var queriedSessions: [Session] = []
        for sessionRow in sessions.order(startTime.desc)
        {
            var session = Session(id: sessionRow[id], startTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[startTime])),
                endTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[endTime])))
            queriedSessions.append(session)
        }
        return queriedSessions
    }
    
    
    /*
        Removes given session from database.
    
        @methodtype Command
        @pre Session must exist
        @post Session has been removed
    */
    func removeSession(session: Session)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        sessions.filter(id == session.id).delete()!
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
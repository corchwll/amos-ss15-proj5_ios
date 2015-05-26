//
//  SessionDAO.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 28/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

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
        for sessionRow in sessions.filter(projectId == project.id)
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
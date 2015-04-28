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
    let projectId = Expression<Int>("project_id")
    let startTime = Expression<Int>("timestamp_start")
    let endTime = Expression<Int>("timestamp_end")
    
    
    func addSession(session: Session, project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]

        sessions.insert(id <- session.id, projectId <- project.id, startTime <- (Int(session.startTime.timeIntervalSince1970)),
            endTime <- (Int(session.endTime.timeIntervalSince1970)))!
    }
    
    
    func getSessions()->[Session]
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        var queriedSessions: [Session] = []
        for sessionRow in sessions
        {
            var session = Session(id: sessionRow[id], startTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[startTime])),
                endTime: NSDate(timeIntervalSince1970: NSTimeInterval(sessionRow[endTime])))
            queriedSessions.append(session)
        }
        return queriedSessions
    }
}
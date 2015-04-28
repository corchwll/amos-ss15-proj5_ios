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
    let id = Expression<Int64>("id")
    let projectId = Expression<Int64>("project_id")
    let startTime = Expression<Int64>("startTime")
    let endTime = Expression<Int64>("endTime")
    
    
    func addSession(session: Session, project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        //todo: fix date issue
        sessions.insert(id <- session.id, projectId <- project.id)!
    }
    
    
    func getSessions()->[Session]
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let sessions = database["sessions"]
        
        var queriedSessions: [Session] = []
        for sessionRow in sessions
        {
            //todo: fix date issue
            var session = Session(id: sessionRow[id], startTime: NSDate(), endTime: NSDate())
            queriedSessions.append(session)
        }
        return queriedSessions
    }
}
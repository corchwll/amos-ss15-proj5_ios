//
//  SQLiteDAOFactory.swift
//  MobileTimeRecording
//
//  Created by cdan on 26/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation
import SQLite


struct SQLiteDAOFactory
{
    static let sqliteDatabase = Database("path/to/db.sqlite3")
    
    
    static func getProjectDAO()->ProjectDAO
    {
        return ProjectDAO()
    }
}

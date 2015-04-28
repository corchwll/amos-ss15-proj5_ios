//
//  SQLiteDAOFactory.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 26/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation
import SQLite


let sqliteHelper = SQLiteHelper()


class SQLiteHelper
{
    let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
    private var sqliteDatabase: Database!
    
    
    init()
    {
        copyDatabaseIfNotExist()
        sqliteDatabase = Database("\(path)/db.sqlite3")
    }
    
    
    func copyDatabaseIfNotExist()
    {
        let fileManager = NSFileManager()
        let rawSQLiteFilePath: String = NSBundle.mainBundle().pathForResource("db", ofType: "sqlite3")!
        println("path ready")
        println(path + "/db.sqlite3")
        if !fileManager.fileExistsAtPath("\(path)/db.sqlite3")
        {
            fileManager.copyItemAtPath(rawSQLiteFilePath, toPath: "\(path)/db.sqlite3", error:nil)
            println("copied")
        }
        else
        {
            println("no need to copy")
        }
    }
    
    
    func getSQLiteDatabase()->Database
    {
        return sqliteDatabase
    }
}

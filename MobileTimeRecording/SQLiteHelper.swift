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
        let rawSQLiteFilePath = NSBundle.mainBundle().pathForResource("myData", ofType: "sqlite")!
        
        if !fileManager.fileExistsAtPath(path)
        {
            fileManager.copyItemAtPath(rawSQLiteFilePath, toPath: path, error:nil)
        }
    }
    
    
    func getSQLiteDatabase()->Database
    {
        return sqliteDatabase
    }
}

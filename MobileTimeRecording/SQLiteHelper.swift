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
    let databaseFileName = "db"
    let databaseFileExtension = "sqlite3"
    let databasePath: String!
    private var sqliteDatabase: Database!
    
    
    /*
        Constructor for helper class, initializing database if necessary and copies database file into documents directory.
    
        @methodtype Constructor
        @pre Correct database name and extension
        @post Fully working sqlite database
    */
    init()
    {
        databasePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String + "/\(databaseFileName).\(databaseFileExtension)"
        copyDatabaseIfNotExist()
        sqliteDatabase = Database("\(databasePath)")
    }
    
    
    /*
        Looks up database file, if not available, copies shiped database file from main bundle to document directory.
    
        @methodtype Command
        @pre Correct path and database file (need to copie database file into main bundle during build phase)
        @post Copied database inside document directory
    */
    func copyDatabaseIfNotExist()
    {
        let fileManager = NSFileManager()
        let rawSQLiteFilePath: String = NSBundle.mainBundle().pathForResource(databaseFileName, ofType: databaseFileExtension)!

        if !fileManager.fileExistsAtPath("\(databasePath)")
        {
            fileManager.copyItemAtPath(rawSQLiteFilePath, toPath: "\(databasePath)", error:nil)
        }
    }
    
    
    /*
        Return database object for further use (executing queries, etc..).
    
        @methodtype Getter
        @pre Database was initialized successfully
        @post Working database object
    */
    func getSQLiteDatabase()->Database
    {
        return sqliteDatabase
    }
}

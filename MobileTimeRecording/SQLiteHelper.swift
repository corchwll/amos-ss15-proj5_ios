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
        sqliteDatabase.foreignKeys = true
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

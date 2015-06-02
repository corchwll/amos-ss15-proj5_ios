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


let projectDAO = ProjectDAO()


class ProjectDAO
{
    let id = Expression<String>("id")
    let name = Expression<String>("name")
    let finalDate = Expression<Int>("final_date")
    let isArchived = Expression<Bool>("is_archived")
    
    
    /*
        Stores given project into sqlite database.
    
        @methodtype Command
        @pre Valid database connection
        @post Persistent project
    */
    func addProject(project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        projects.insert(id <- project.id, name <- project.name, finalDate <- (Int(project.finalDate.timeIntervalSince1970)),
            isArchived <- project.isArchived)!
    }
    
    
    /*
        Returns all projects from sqlite database.
    
        @methodtype Query
        @pre Valid database connection
        @post All projects from database
    */
    func getProjects()->[Project]
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        var queriedProjects: [Project] = []
        for projectRow in projects.filter(isArchived == false)
        {
            var project = Project(id: projectRow[id], name: projectRow[name], finalDate: NSDate(timeIntervalSince1970: NSTimeInterval(projectRow[finalDate])),
                isArchived: projectRow[isArchived])
            queriedProjects.append(project)
        }
        return queriedProjects
    }
    
    
    /*
        Returns project with the given id if available.
        
        @methodtype Query
        @pre Valid database connection, id must be valid
        @post Return requested project
    */
    func getProject(projectId: String)->Project?
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        let query = projects.filter(id == projectId)
        if let row = query.first
        {
            return Project(id: row[id], name: row[name], finalDate: NSDate(timeIntervalSince1970: NSTimeInterval(row[finalDate])),
                isArchived: row[isArchived])
        }
        else
        {
            return nil
        }
    }
    
    
    /*
        Archives project, meaning that the projects 'isArchived' flag is set to true.
        
        @methodtype Command
        @pre Valid database connection
        @post Project has been archived
    */
    func archiveProject(project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        projects.filter(id == project.id).update(isArchived <- true)!
    }
    
    
    /*
        Removes given project completely from database.
        
        @methodtype Command
        @pre Valid database connection
        @post Project has been removed
    */
    func removeProject(project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        projects.filter(id == project.id).delete()!
    }
}

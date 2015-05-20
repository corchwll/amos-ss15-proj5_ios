//
//  ProjectDAO.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 26/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation
import SQLite


let projectDAO = ProjectDAO()


class ProjectDAO
{
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
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
        
        projects.insert(id <- project.id, name <- project.name, isArchived <- project.isArchived)!
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
            var project = Project(id: projectRow[id], name: projectRow[name], isArchived: projectRow[isArchived])
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
    func getProject(projectId: Int)->Project
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        let query = projects.filter(id == projectId)
        return Project(id: query.first![id], name: query.first![name], isArchived: query.first![isArchived])
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
}

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
    
    
    /*
        Stores given project into sqlite database.
    
        @methodtype Command
        @pre Project paramter != nil
        @post Persistent project
    */
    func addProject(project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        projects.insert(id <- project.id, name <- project.name)!
    }
    
    
    /*
        Returns all projects from sqlite database.
    
        @methodtype Query
        @pre -
        @post All projects from database
    */
    func getProjects()->[Project]
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        var queriedProjects: [Project] = []
        for projectRow in projects
        {
            var project = Project(id: projectRow[id], name: projectRow[name])
            queriedProjects.append(project)
        }
        return queriedProjects
    }
    
    
    func getProject(projectId: Int)->Project
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        let query = projects.filter(id == projectId)
        return Project(id: query.first![id], name: query.first![name])
    }
}

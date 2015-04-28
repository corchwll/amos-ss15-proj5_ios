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
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    
    
    func addProject(project: Project)
    {
        let database = sqliteHelper.getSQLiteDatabase()
        let projects = database["projects"]
        
        projects.insert(id <- project.id, name <- project.name)!
    }
    
    
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
}

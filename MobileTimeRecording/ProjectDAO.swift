//
//  ProjectDAO.swift
//  MobileTimeRecording
//
//  Created by cdan on 26/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation


class ProjectDAO
{
    func getProject()->Project
    {
        let db = SQLiteDAOFactory.sqliteDatabase
        //todo: some query stuff
        return Project(id: 1, name: "test")
    }
}

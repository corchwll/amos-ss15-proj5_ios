//
//  Project.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 26/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation


class Project
{
    var id: Int
    var name: String
    
    
    /*
        Constructor for model class, representing projects.
    
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized project
    */
    init(id: Int, name: String)
    {
        self.id = id
        self.name = name
    }
    
    
    static func isValidId(id: String)->Bool
    {
        return id.toInt() != nil && count(id) == 5
    }
}

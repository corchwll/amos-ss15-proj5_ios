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
    var isArchived: Bool

    
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
        self.isArchived = false
    }
    
    
    /*
        Constructor for model class, representing projects.
    
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized project
    */
    convenience init(id: Int, name: String, isArchived: Bool)
    {
        self.init(id: id, name: name)
        self.isArchived = isArchived
    }
    
    
    /*
        Asserts if id is valid string(consists only of digits with length 5).
        
        @methodtype Assertion
        @pre -
        @post Returns if id is valid
    */
    static func isValidId(id: String)->Bool
    {
        return id.toInt() != nil && count(id) == 5
    }
}

//
//  Session.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 28/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation


class Session
{
    var id: Int
    var startTime: NSDate
    var endTime: NSDate
    
    
    /*
        Constructor for model class, representing sessions.
    
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized session
    */
    init(id: Int, startTime: NSDate, endTime: NSDate)
    {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
    }
}

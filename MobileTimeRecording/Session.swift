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
    var id: Int64
    var startTime: NSDate
    var endTime: NSDate
    
    
    init(id: Int64, startTime: NSDate, endTime: NSDate)
    {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
    }
}

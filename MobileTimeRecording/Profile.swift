//
//  Profile.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 02/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation


class Profile
{
    var firstname: String
    var lastname: String
    var employeeId: String
    
    var weeklyWorkingTime: String?
    var totalVacationTime: String?
    var currentVacationTime: String?
    var currentOvertime: String?
   
    
    /*
        Empty constructor for model class, representing a profile.
        
        @methodtype Constructor
        @pre -
        @post Initialized profile with default paramters
    */
    init()
    {
        self.firstname = "default"
        self.lastname = "default"
        self.employeeId = "0"
    }
    
    
    /*
        Constructor for model class, representing a profile.
        
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized profile
    */
    init(firstname: String, lastname: String, employeeId: String)
    {
        self.firstname = firstname
        self.lastname = lastname
        self.employeeId = employeeId
    }
    
    
    /*
        Constructor for model class, representing a profile.
        
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized profile
    */
    convenience init(firstname: String, lastname: String, employeeId: String, weeklyWorkingTime: String, totalVacationTime: String, currentVacationTime: String, currentOvertime: String)
    {
        self.init(firstname: firstname, lastname: lastname, employeeId: employeeId)
        self.weeklyWorkingTime = weeklyWorkingTime
        self.totalVacationTime = totalVacationTime
        self.currentVacationTime = currentVacationTime
        self.currentOvertime = currentOvertime
    }
    
    
    static func isValidId(id: String)->Bool
    {
        return id.toInt() != nil && count(id) == 5
    }
    
    
    /*
        Returns string representation of user profile
        
        @methodtype Convertion
        @pre -
        @post String representation of user profile
    */
    func asString()->String
    {
        return "\(firstname) \(lastname); \(employeeId); \(weeklyWorkingTime); \(totalVacationTime); \(currentVacationTime); \(currentOvertime)"
    }
}
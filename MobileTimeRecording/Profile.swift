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
    var forename: String
    var surname: String
    var employeeId: String
    
    var hoursPerWeek: String?
    var vacation: String?
   
    
    /*
        Empty constructor for model class, representing a profile.
        
        @methodtype Constructor
        @pre -
        @post Initialized profile with default paramters
    */
    init()
    {
        self.forename = "default"
        self.surname = "default"
        self.employeeId = "0"
    }
    
    
    /*
        Constructor for model class, representing a profile.
        
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized profile
    */
    init(forename: String, surname: String, employeeId: String)
    {
        self.forename = forename
        self.surname = surname
        self.employeeId = employeeId
    }
    
    
    /*
        Constructor for model class, representing a profile.
        
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized profile
    */
    convenience init(forename: String, surname: String, employeeId: String, hoursPerWeek: String, vacation: String)
    {
        self.init(forename: forename, surname: surname, employeeId: employeeId)
        self.hoursPerWeek = hoursPerWeek
        self.vacation = vacation
    }
    
    
    /*
        Returns string representation of user profile
        
        @methodtype Convertion
        @pre -
        @post String representation of user profile
    */
    func asString()->String
    {
        return "\(forename) \(surname); \(employeeId); \(hoursPerWeek); \(vacation)"
    }
}
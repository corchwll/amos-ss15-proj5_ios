//
//  ProfileDAO.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 02/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import Foundation


let profileDAO = ProfileDAO()


class ProfileDAO
{
    var userDefaults = NSUserDefaults()
    private var forenameKey = "forename_key"
    private var surnameKey = "surname_key"
    private var employeeIdKey = "employeeId_key"
    private var hoursPerWeekKey = "hoursPerWeek_key"
    private var vacationKey = "vacation_key"
    
    
    func addProfile(profile: Profile)
    {
        userDefaults.setObject(profile.forename, forKey: forenameKey)
        userDefaults.setObject(profile.surname, forKey: surnameKey)
        userDefaults.setObject(profile.employeeId, forKey: employeeIdKey)
        userDefaults.setObject(profile.hoursPerWeek, forKey: hoursPerWeekKey)
        userDefaults.setObject(profile.vacation, forKey: vacationKey)
    }
    
    
    func getProfile()->Profile
    {
        var profile = Profile()
        profile.forename = userDefaults.stringForKey(forenameKey)!
        profile.surname = userDefaults.stringForKey(surnameKey)!
        profile.employeeId = userDefaults.stringForKey(employeeIdKey)!
        profile.hoursPerWeek = userDefaults.stringForKey(hoursPerWeekKey)
        profile.vacation = userDefaults.stringForKey(vacationKey)
        
        return profile
    }
}
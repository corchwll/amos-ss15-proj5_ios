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
    private var firstnameKey = "firstname_key"
    private var lastnameKey = "lastname_key"
    private var employeeIdKey = "employee_id_key"
    private var weeklyWorkingTimeKey = "weekly_working_time_key"
    private var totalVacationTimeKey = "total_vacation_time_key"
    private var currentVacationTimeKey = "current_vacation_time_key"
    private var currentOvertimeKey = "current_overtime_key"
    
    private var userRegisteredKey = "user_registered"
    
    
    /*
        Adds new profile into user defaults.
        
        @methodtype Command
        @pre -
        @post Stored user profile
    */
    func setProfile(profile: Profile)
    {
        userDefaults.setObject(profile.firstname, forKey: firstnameKey)
        userDefaults.setObject(profile.lastname, forKey: lastnameKey)
        userDefaults.setObject(profile.employeeId, forKey: employeeIdKey)
        userDefaults.setObject(profile.weeklyWorkingTime, forKey: weeklyWorkingTimeKey)
        userDefaults.setObject(profile.totalVacationTime, forKey: totalVacationTimeKey)
        userDefaults.setObject(profile.currentVacationTime, forKey: currentVacationTimeKey)
        userDefaults.setObject(profile.currentOvertime, forKey: currentOvertimeKey)
        
        userDefaults.setBool(true, forKey: userRegisteredKey)
    }
    
    
    /*
        Returns profile from user defaults.
        
        @methodtype Query
        @pre -
        @post Get user profile
    */
    func getProfile()->Profile?
    {
        if let employeeId = userDefaults.stringForKey(employeeIdKey)
        {
            var profile = Profile()
            profile.firstname = userDefaults.stringForKey(firstnameKey)!
            profile.lastname = userDefaults.stringForKey(lastnameKey)!
            profile.employeeId = userDefaults.stringForKey(employeeIdKey)!
            profile.weeklyWorkingTime = userDefaults.stringForKey(weeklyWorkingTimeKey)
            profile.totalVacationTime = userDefaults.stringForKey(totalVacationTimeKey)
            profile.currentVacationTime = userDefaults.stringForKey(currentVacationTimeKey)
            profile.currentOvertime = userDefaults.stringForKey(currentOvertimeKey)
            
            return profile
        }
        return nil
    }
    
    
    /*
        Removes profile from user defaults.
        
        @methodtype Command
        @pre -
        @post All objects are removed, profile is not registered anymore
    */
    func removeProfile()
    {
        userDefaults.removeObjectForKey(firstnameKey)
        userDefaults.removeObjectForKey(lastnameKey)
        userDefaults.removeObjectForKey(employeeIdKey)
        userDefaults.removeObjectForKey(weeklyWorkingTimeKey)
        userDefaults.removeObjectForKey(totalVacationTimeKey)
        userDefaults.removeObjectForKey(currentVacationTimeKey)
        userDefaults.removeObjectForKey(currentOvertimeKey)
        
        userDefaults.setBool(false, forKey: userRegisteredKey)
    }
    
    
    /*
        Asserts if profile is already available, meaning user is registered or not.
        
        @methodtype Assertion
        @pre -
        @post Assert if user is registered or not
    */
    func isRegistered()->Bool
    {
        return userDefaults.boolForKey(userRegisteredKey)
    }
}
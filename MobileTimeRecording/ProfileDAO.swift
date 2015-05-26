/*
    Mobile Time Accounting
    Copyright (C) 2015

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
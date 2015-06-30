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
    private var registrationDateKey = "registration_date_key"
    
    
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
        userDefaults.setObject(Int(profile.registrationDate.timeIntervalSince1970), forKey: registrationDateKey)
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
            let firstname = userDefaults.stringForKey(firstnameKey)!
            let lastname = userDefaults.stringForKey(lastnameKey)!
            let weeklyWorkingTime = userDefaults.integerForKey(weeklyWorkingTimeKey)
            let totalVacationTime = userDefaults.integerForKey(totalVacationTimeKey)
            let currentVacationTime = userDefaults.integerForKey(currentVacationTimeKey)
            let currentOvertime = userDefaults.integerForKey(currentOvertimeKey)
            let registrationDate = NSDate(timeIntervalSince1970: NSTimeInterval(userDefaults.integerForKey(registrationDateKey)))
            
            return Profile(firstname: firstname, lastname: lastname, employeeId: employeeId, weeklyWorkingTime: weeklyWorkingTime, totalVacationTime: totalVacationTime, currentVacationTime: currentVacationTime, currentOvertime: currentOvertime, registrationDate: registrationDate)
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
    }
    
    
    /*
        Asserts if profile is already available, meaning user is registered or not.
        
        @methodtype Assertion
        @pre -
        @post Assert if user is registered or not
    */
    func isRegistered()->Bool
    {
        if let employeeId = userDefaults.stringForKey(employeeIdKey)
        {
            return true
        }
        return false
    }
}
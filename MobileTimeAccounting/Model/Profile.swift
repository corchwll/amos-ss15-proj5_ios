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


class Profile
{
    var firstname: String
    var lastname: String
    var employeeId: String
    var weeklyWorkingTime: Int
    var totalVacationTime: Int
    var currentVacationTime: Int
    var currentOvertime: Int
    var registrationDate: NSDate
   
    
    /*
        Constructor for model class, representing a profile.
        
        @methodtype Constructor
        @pre -
        @post Initialized profile
    */
    init(firstname: String, lastname: String, employeeId: String, weeklyWorkingTime: Int, totalVacationTime: Int, currentVacationTime: Int, currentOvertime: Int)
    {
        self.firstname = firstname
        self.lastname = lastname
        self.employeeId = employeeId
        self.weeklyWorkingTime = weeklyWorkingTime
        self.totalVacationTime = totalVacationTime
        self.currentVacationTime = currentVacationTime
        self.currentOvertime = currentOvertime
        self.registrationDate = NSDate()
    }
    
    
    /*
        Constructor for model class, representing a profile.
        
        @methodtype Constructor
        @pre -
        @post Initialized profile
    */
    convenience init(firstname: String, lastname: String, employeeId: String, weeklyWorkingTime: Int, totalVacationTime: Int, currentVacationTime: Int, currentOvertime: Int, registrationDate: NSDate)
    {
        self.init(firstname: firstname, lastname: lastname, employeeId: employeeId, weeklyWorkingTime: weeklyWorkingTime, totalVacationTime: totalVacationTime, currentVacationTime: currentVacationTime, currentOvertime: currentOvertime)
        self.registrationDate = registrationDate
    }
    
    
    /*
        Asserts wether id is valid or not(consists only of digits of length 5).
        
        @methodtype Assertion
        @pre -
        @post -
    */
    static func isValidId(id: String)->Bool
    {
        return id.toInt() != nil && count(id) == 5
    }
    
    
    /*
        Asserts wether weekly working time is valid or not(must be a number between 10 and 50).
        
        @methodtype Assertion
        @pre -
        @post -
    */
    static func isValidWeeklyWorkingTime(weeklyWorkingTime: String)->Bool
    {
        if let time = weeklyWorkingTime.toInt()
        {
            return time >= 10 && time <= 50
        }
        return false
    }
    
    
    /*
        Asserts wether total vacation time is valid or not(must be a number between 0 and 40).
        
        @methodtype Assertion
        @pre -
        @post -
    */
    static func isValidTotalVacationTime(totalVacationTime: String)->Bool
    {
        if let time = totalVacationTime.toInt()
        {
            return time >= 0 && time <= 40
        }
        return false
    }
    
    
    /*
        Asserts wether current vacation time is valid or not(must be a number greater or equals 0).
        
        @methodtype Assertion
        @pre -
        @post -
    */
    static func isValidCurrentVacationTime(currentVacationTime: String)->Bool
    {
        if let time = currentVacationTime.toInt()
        {
            return time >= 0
        }
        return false
    }
    
    
    /*
        Asserts wether current over time is valid or not(must be a number).
        
        @methodtype Assertion
        @pre -
        @post -
    */
    static func isValidCurrentOvertime(currentOvertime: String)->Bool
    {
        if let time = currentOvertime.toInt()
        {
            return true
        }
        return false
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
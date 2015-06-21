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


let settings = Settings()


class Settings
{
    var userDefaults = NSUserDefaults()
    static let EnableProjectsSortingByDistance = "EnableProjectsSortingByDistance"
    
    
    /*
        Sets boolean preference for a given key.
        
        @methodtype Command
        @pre Key is valid
        @post Preference is set to boolean value
    */
    func setPreference(key: String, value: Bool)
    {
        userDefaults.setBool(value, forKey: key)
    }
    
    
    /*
        Returns requested preference of a given key.
        
        @methodtype Query
        @pre Key is valid
        @post Preference is returned
    */
    func getPreference(key: String)->Bool
    {
        return userDefaults.boolForKey(key)
    }
}

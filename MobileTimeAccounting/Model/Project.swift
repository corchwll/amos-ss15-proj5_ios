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
import MapKit


class Project
{
    var id: String
    var name: String
    var finalDate: NSDate
    var location: CLLocation
    var isArchived: Bool

    
    /*
        Constructor for model class, representing projects.
        
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized project
    */
    init(id: String, name: String)
    {
        self.id = id
        self.name = name
        self.finalDate = NSDate(timeIntervalSince1970: NSTimeInterval(0))
        self.location = CLLocation(latitude: 0.0, longitude: 0.0)
        self.isArchived = false
    }
    
    
    /*
        Constructor for model class, representing projects.
        
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized project
    */
    convenience init(id: String, name: String, finalDate: NSDate?, latitude: Double?, longitude: Double?)
    {
        self.init(id: id, name: name)
        
        if finalDate != nil
        {
            self.finalDate = finalDate!
        }
        
        if latitude != nil && longitude != nil
        {
            self.location = CLLocation(latitude: latitude!, longitude: longitude!)
        }
    }
    
    
    /*
        Constructor for model class, representing projects.
    
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized project
    */
    convenience init(id: String, name: String, finalDate: NSDate?, latitude: Double?, longitude: Double?, isArchived: Bool)
    {
        self.init(id: id, name: name, finalDate: finalDate, latitude: latitude, longitude: longitude)
        self.isArchived = isArchived
    }
    
    
    /*
        Asserts if id is valid string(consists only of digits with length 5).
        
        @methodtype Assertion
        @pre -
        @post Returns if id is valid
    */
    static func isValidId(id: String)->Bool
    {
        return id.toInt() != nil && count(id) == 5
    }
}

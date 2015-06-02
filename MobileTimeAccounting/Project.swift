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


class Project
{
    var id: String
    var name: String
    var finalDate: NSDate
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
        self.isArchived = false
    }
    
    
    /*
        Constructor for model class, representing projects.
        
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized project
    */
    convenience init(id: String, name: String, finalDate: NSDate)
    {
        self.init(id: id, name: name)
        self.finalDate = finalDate
        self.isArchived = false
    }
    
    
    /*
        Constructor for model class, representing projects.
    
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized project
    */
    convenience init(id: String, name: String, finalDate: NSDate, isArchived: Bool)
    {
        self.init(id: id, name: name, finalDate: finalDate)
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

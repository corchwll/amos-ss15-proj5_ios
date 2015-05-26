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


class Session
{
    var id: Int
    var startTime: NSDate
    var endTime: NSDate
    
    
    /*
        Empty constructor for model class, representing sessions.
        
        @methodtype Constructor
        @pre -
        @post Initialized session with default paramters
    */
    init()
    {
        self.id = 0
        self.startTime = NSDate()
        self.endTime = NSDate()
    }
    
    
    /*
        Constructor for model class, representing sessions.
    
        @methodtype Constructor
        @pre Correct paramters != nil
        @post Initialized session
    */
    init(id: Int, startTime: NSDate, endTime: NSDate)
    {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
    }
}

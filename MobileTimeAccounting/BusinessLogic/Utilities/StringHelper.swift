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


extension String
{
    /*
        Returns double representation of the string. If string is no double value, nil is returned.
        
        @methodtype Convertion
        @pre -
        @post Returns double value or nil
    */
    func toDouble()->Double?
    {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "en_US")
        
        if let number = numberFormatter.numberFromString(self)
        {
            return number.doubleValue
        }
        return nil
    }
}

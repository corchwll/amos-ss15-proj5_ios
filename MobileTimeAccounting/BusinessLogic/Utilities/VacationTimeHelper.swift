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


let vacationTimeHelper = VacationTimeHelper()


class VacationTimeHelper
{
    let vacationProject = Project(id: "00001", name: "Holiday")
    
    
    /*
        Calculates current vacation days left.
        
        @methodtype Helper
        @pre Profile is set
        @post Returns current vacation days left
    */
    func getCurrentVacationDays()->Int
    {
        let vacationSessions = sessionDAO.getSessions(vacationProject)
        var vacationDays = 0
        
        for vacationSession in vacationSessions
        {
            vacationDays++
        }
        return vacationDays
    }
}

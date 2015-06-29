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
    let ExpiringMonth = 4
    let calendar = NSCalendar.currentCalendar()
    let vacationProject = Project(id: "00001", name: "Vacation")
    
    
    /*
        Calculates current vacation days left.
        
        @methodtype Helper
        @pre Profile is set
        @post Returns current vacation days left
    */
    func getCurrentVacationDaysLeft(currentDate: NSDate)->Int
    {
        let totalVacationDays = profileDAO.getProfile()!.totalVacationTime!.toInt()!
        let currentDateCompontents = calendar.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: currentDate)
        var currentVacationDays = getVacationDaysForYear(currentDateCompontents.year)
        
        return profileDAO.getProfile()!.totalVacationTime!.toInt()! - currentVacationDays
    }
    
    
    /*
        Calculates vacation days for a given year from delimiter month this year to delimiter month next year.
        
        @methodtype Helper
        @pre Delimiter month set to valid month value
        @post Returns vacation days for a given year
    */
    private func getVacationDaysForYear(year: Int)->Int
    {
        let fromTime = NSDate(month: ExpiringMonth, year: year, calendar: calendar).startOfMonth()!
        let toTime = fromTime.dateByAddingMonths(11)!.endOfMonth()!
        
        return getVacationDaysInRange(fromTime, toTime: toTime)
    }
    
    
    /*
        Calculates all vacation days in a given time range.
        
        @methodtype Helper
        @pre Valid time range (from time before to time)
        @post Vacation day in range are returned
    */
    private func getVacationDaysInRange(fromTime: NSDate, toTime: NSDate)->Int
    {
        let vacationSessions = sessionDAO.getSessions(fromTime, toTime: toTime, project: vacationProject)

        var vacationDays = 0
        for vacationSession in vacationSessions
        {
            vacationDays++
        }
        return vacationDays
    }
}

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

import XCTest


/*
    Naming convention for all tests: 'UnitOfWork_StateUnderTest_ExpectedBehavior'
*/
class VacationTimeHelperTests: XCTestCase
{
    let profile = Profile(firstname: "Max", lastname: "Mueller", employeeId: "12345", weeklyWorkingTime: "30", totalVacationTime: "30", currentVacationTime: "0", currentOvertime: "0")
    let vacationProject = Project(id: "00001", name: "Vacation")
    var vacationSessions =
    [
        (day: 1, month: 4, year: 2016), //-
        (day: 31, month: 3, year: 2015), //-
        (day: 1, month: 4, year: 2015), //1
        (day: 15, month: 8, year: 2015), //2
        (day: 3, month: 10, year: 2015), //3
        (day: 1, month: 11, year: 2015), //4
        (day: 25, month: 12, year: 2015), //5
        (day: 31, month: 3, year: 2016), //6
        (day: 2, month: 4, year: 2015), //7
        (day: 6, month: 4, year: 2015), //8
        (day: 14, month: 5, year: 2015), //9
        (day: 25, month: 5, year: 2015), //10
        (day: 4, month: 6, year: 2015)  //11
    ]
    
    
    override func setUp()
    {
        super.setUp()
        
        profileDAO.setProfile(profile)
        
        for vacationSession in vacationSessions
        {
            sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: vacationSession.day, month: vacationSession.month, year: vacationSession.year, calendar: NSCalendar.currentCalendar()), endTime: NSDate(hour: 16, minute: 0, second: 0, day: vacationSession.day, month: vacationSession.month, year: vacationSession.year, calendar: NSCalendar.currentCalendar())), project: vacationProject)
        }
    }
    
    
    override func tearDown()
    {
        sessionDAO.removeSessions(vacationProject)
        profileDAO.removeProfile()
        
        super.tearDown()
    }

    
    func testGetCurrentVacationDays_VacationSessionsAdded_ReturnCurrentVacationDays()
    {
        let date = NSDate(month: 6, year: 2015, calendar: NSCalendar.currentCalendar())
        let pass = vacationTimeHelper.getCurrentVacationDaysLeft(date) == 19
        XCTAssert(pass, "Pass")
    }
    
    
    func testIsExpiring_CurrentMonthIsLastMonth_IsExpiring()
    {
        let date = NSDate(month: 3, year: 2015, calendar: NSCalendar.currentCalendar())
        let pass = vacationTimeHelper.isExpiring(date)
        XCTAssert(pass, "Pass")
    }
    
    
    func testIsExpiring_CurrentMonthIsAfterMonth_IsNotExpiring()
    {
        let date = NSDate(month: 4, year: 2015, calendar: NSCalendar.currentCalendar())
        let pass = !vacationTimeHelper.isExpiring(date)
        XCTAssert(pass, "Pass")
    }
}

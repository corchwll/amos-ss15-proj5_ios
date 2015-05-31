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
    let vacationProject = Project(id: "00001", name: "Holiday", finalDate: NSDate(timeIntervalSinceReferenceDate: 0))
    var vacationSessions =
    [
        (day: 1, month: 1, year: 2015), //1
        (day: 6, month: 1, year: 2015), //2
        (day: 1, month: 5, year: 2015), //3
        (day: 15, month: 8, year: 2015), //4
        (day: 3, month: 10, year: 2015), //5
        (day: 1, month: 11, year: 2015), //6
        (day: 25, month: 12, year: 2015), //7
        (day: 26, month: 12, year: 2015), //8
        (day: 3, month: 4, year: 2015), //9
        (day: 6, month: 4, year: 2015), //10
        (day: 14, month: 5, year: 2015), //11
        (day: 25, month: 5, year: 2015), //12
        (day: 4, month: 6, year: 2015)  //13
    ]
    
    
    override func setUp()
    {
        super.setUp()
        
        for vacationSession in vacationSessions
        {
            var vacationDate = NSDateComponents()
            vacationDate.day = vacationSession.day
            vacationDate.month = vacationSession.month
            vacationDate.year = vacationSession.year
            sessionDAO.addSession(Session(id: 0, startTime: NSCalendar.currentCalendar().dateFromComponents(vacationDate)!, endTime: NSCalendar.currentCalendar().dateFromComponents(vacationDate)!), project: vacationProject)
        }
    }
    
    
    override func tearDown()
    {
        sessionDAO.removeSessions(vacationProject)
        
        super.tearDown()
    }

    
    func testGetCurrentVacationDays_VacationSessionsAdded_ReturnCurrentVacationDays()
    {
        let pass = vacationTimeHelper.getCurrentVacationDays() == 13
        XCTAssert(pass, "Pass")
    }
}

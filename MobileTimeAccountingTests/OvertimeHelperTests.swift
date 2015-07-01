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

import UIKit
import XCTest


/*
    Naming convention for all tests: 'UnitOfWork_StateUnderTest_ExpectedBehavior'
*/
class OvertimeHelperTests: XCTestCase
{
    let profile = Profile(firstname: "Max", lastname: "Mueller", employeeId: "12345", weeklyWorkingTime: 40, totalVacationTime: 30, currentVacationTime: 0, currentOvertime: 0, registrationDate: NSDate(hour: 8, minute: 0, second: 0, day: 1, month: 6, year: 2015, calendar: NSCalendar.currentCalendar()))
    let project = Project(id: "10001", name: "Test Project 1")
    let currentDate = NSDate(day: 3, month: 7, year: 2015, calendar: NSCalendar.currentCalendar())
    let overtimeHelper = OvertimeHelper()
    var sessions =
    [
        (day: 1, month: 6, year: 2015),
        (day: 2, month: 6, year: 2015),
        (day: 3, month: 6, year: 2015),
        (day: 5, month: 6, year: 2015),
        (day: 8, month: 6, year: 2015),
        (day: 9, month: 6, year: 2015),
        (day: 10, month: 6, year: 2015),
        (day: 11, month: 6, year: 2015),
        (day: 12, month: 6, year: 2015),
        (day: 15, month: 6, year: 2015),
        (day: 16, month: 6, year: 2015),
        (day: 17, month: 6, year: 2015),
        (day: 18, month: 6, year: 2015),
        (day: 19, month: 6, year: 2015),
        (day: 22, month: 6, year: 2015),
        (day: 23, month: 6, year: 2015),
        (day: 24, month: 6, year: 2015),
        (day: 25, month: 6, year: 2015),
        (day: 26, month: 6, year: 2015),
        (day: 29, month: 6, year: 2015),
        (day: 30, month: 6, year: 2015),
        (day: 1, month: 7, year: 2015),
        (day: 2, month: 7, year: 2015)
    ]
    
    
    override func setUp()
    {
        super.setUp()

        profileDAO.setProfile(profile)
        projectDAO.addProject(project)
    }
    
    
    override func tearDown()
    {
        sessionDAO.removeSessions(project)
        projectDAO.removeProject(project)
        profileDAO.removeProfile()
        
        super.tearDown()
    }

    
    func testGetCurrentOvertime_SessionAddedToProjectWithoutInterruption_OvertimeIsZero()
    {
        var pass = false
        
        for session in sessions
        {
            sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: session.day, month: session.month, year: session.year, calendar: NSCalendar.currentCalendar()), endTime: NSDate(hour: 16, minute: 0, second: 0, day: session.day, month: session.month, year: session.year, calendar: NSCalendar.currentCalendar())), project: project)
        }
        pass = overtimeHelper.getCurrentOvertime(currentDate) == 0
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testGetCurrentOvertime_SessionAddedToProjectExceptLastSession_OvertimeIsOneDay()
    {
        var pass = false
        
        for i in 0...21
        {
            let session = sessions[i]
            sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: session.day, month: session.month, year: session.year, calendar: NSCalendar.currentCalendar()), endTime: NSDate(hour: 16, minute: 0, second: 0, day: session.day, month: session.month, year: session.year, calendar: NSCalendar.currentCalendar())), project: project)
        }
        pass = overtimeHelper.getCurrentOvertime(currentDate) == -8
        
        XCTAssert(pass, "Pass")
    }
    
    func testGetCurrentOvertime_SessionAddedToProjectWithGaps_OvertimeIsNegative()
    {
        var pass = false
        
        for i in 0...10
        {
            let session = sessions[i]
            sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: session.day, month: session.month, year: session.year, calendar: NSCalendar.currentCalendar()), endTime: NSDate(hour: 16, minute: 0, second: 0, day: session.day, month: session.month, year: session.year, calendar: NSCalendar.currentCalendar())), project: project)
        }
        
        for i in 13...22
        {
            let session = sessions[i]
            sessionDAO.addSession(Session(id: 0, startTime: NSDate(hour: 8, minute: 0, second: 0, day: session.day, month: session.month, year: session.year, calendar: NSCalendar.currentCalendar()), endTime: NSDate(hour: 16, minute: 0, second: 0, day: session.day, month: session.month, year: session.year, calendar: NSCalendar.currentCalendar())), project: project)
        }
        pass = overtimeHelper.getCurrentOvertime(currentDate) == -16
        
        XCTAssert(pass, "Pass")
    }
}

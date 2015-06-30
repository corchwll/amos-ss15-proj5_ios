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
class ProfileDAOTests: XCTestCase
{
    var profiles: [Profile] = []
    
    
    override func setUp()
    {
        super.setUp()
        
        profiles.append(Profile(firstname: "Max", lastname: "Mueller", employeeId: "12345", weeklyWorkingTime: 30, totalVacationTime: 40, currentVacationTime: 10, currentOvertime: 20))
    }
    
    
    override func tearDown()
    {
        if profileDAO.isRegistered()
        {
            profileDAO.removeProfile()
        }
        profiles.removeAll(keepCapacity: false)
        
        super.tearDown()
    }
    
    
    func testSetProfile_ValidProfile_ProfileIsSet()
    {
        profileDAO.setProfile(profiles.first!)
        
        var pass = true
        if let profile = profileDAO.getProfile()
        {
            pass = pass && profile.firstname == profiles.first?.firstname
            pass = pass && profile.lastname == profiles.first?.lastname
            pass = pass && profile.employeeId == profiles.first?.employeeId
            pass = pass && profile.weeklyWorkingTime == profiles.first?.weeklyWorkingTime
            pass = pass && profile.totalVacationTime == profiles.first?.totalVacationTime
            pass = pass && profile.currentVacationTime == profiles.first?.currentVacationTime
            pass = pass && profile.currentOvertime == profiles.first?.currentOvertime
        }
        else
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testGetProfile_NoProfileIsSet_FoundNilBecauseOfMissingProfile()
    {
        var pass = true
        if let profile = profileDAO.getProfile()
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testRemoveProfile_ProfileIsSet_ProfileIsRemoved()
    {
        profileDAO.setProfile(profiles.first!)
        profileDAO.removeProfile()
        
        var pass = true
        if let profile = profileDAO.getProfile()
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testIsRegistered_ProfileIsSet_ProfileIsRegistered()
    {
        profileDAO.setProfile(profiles.first!)
        
        var pass = true
        if !profileDAO.isRegistered()
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testIsRegistered_ProfileWasRemoved_ProfileIsNotRegisteredAnymore()
    {
        profileDAO.setProfile(profiles.first!)
        profileDAO.removeProfile()
        
        var pass = true
        if profileDAO.isRegistered()
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
}

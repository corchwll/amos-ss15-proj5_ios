//
//  MobileTimeRecordingTests.swift
//  MobileTimeRecordingTests
//
//  Created by cdan on 20/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit
import XCTest

class ProfileDAOTests: XCTestCase
{
    var profiles: [Profile] = []
    
    
    override func setUp()
    {
        super.setUp()
        
        profiles.append(Profile(firstname: "Max", lastname: "Mueller", employeeId: "12345", weeklyWorkingTime: "30", totalVacationTime: "40", currentVacationTime: "10", currentOvertime: "20"))
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
    
    
    func testSetProfile_Valid_Pass()
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
    
    
    func testGetProfile_NoProfileSet_Fail()
    {
        var pass = true
        if let profile = profileDAO.getProfile()
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testRemoveProfile_Valid_Pass()
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
    
    
    func testIsRegistered_ProfileSet_Pass()
    {
        profileDAO.setProfile(profiles.first!)
        
        var pass = true
        if !profileDAO.isRegistered()
        {
            pass = false
        }
        
        XCTAssert(pass, "Pass")
    }
    
    
    func testIsRegistered_ProfileRemoved_Pass()
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

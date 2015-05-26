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
        profiles.removeAll(keepCapacity: false)
        
        super.tearDown()
    }
    
    
    func testAddProfile_Valid_Pass()
    {
        XCTAssert(true, "Pass")
    }
}

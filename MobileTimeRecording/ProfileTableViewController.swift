//
//  ProfileTableViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 08/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var employeeIdLabel: UILabel!
    @IBOutlet weak var weeklyWorkingTimeLabel: UILabel!
    @IBOutlet weak var totalVacationTimeLabel: UILabel!
    
    
    /*
        iOS life-cycle function. Loads user profile.
        
        @methodtype Hook
        @pre Initial user profile is set
        @post User profile loaded
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadProfile()
    }
    
    
    /*
        iOS life-cycle function. Loads user profile.
        
        @methodtype Hook
        @pre Initial user profile is set
        @post User profile loaded
    */
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        loadProfile()
    }
    
    
    /*
        Functions is loading current user profile into ui.
        
        @methodtype Command
        @pre Valid user profile
        @post User profile was loaded into ui
    */
    func loadProfile()
    {
        if let profile = profileDAO.getProfile()
        {
            nameLabel.text = profile.firstname + " " + profile.lastname
            employeeIdLabel.text = profile.employeeId
            weeklyWorkingTimeLabel.text = profile.weeklyWorkingTime
            totalVacationTimeLabel.text = profile.totalVacationTime
        }
    }
}

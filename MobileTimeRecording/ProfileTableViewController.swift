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
    @IBOutlet weak var hoursPerWeekLabel: UILabel!
    @IBOutlet weak var vacationLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadProfile()
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        loadProfile()
    }
    
    
    func loadProfile()
    {
        let profile = profileDAO.getProfile()
        nameLabel.text = profile.forename + " " + profile.surname
        employeeIdLabel.text = profile.employeeId
        hoursPerWeekLabel.text = profile.hoursPerWeek
        vacationLabel.text = profile.vacation
    }
}

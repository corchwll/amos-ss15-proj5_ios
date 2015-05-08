//
//  EditProfileTableViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 08/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController
{
    @IBOutlet weak var forenameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var employeeIdTextField: UITextField!
    @IBOutlet weak var hoursPerWeekTextField: UITextField!
    @IBOutlet weak var vacationTextField: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadProfile()
    }
    
    
    func loadProfile()
    {
        let profile = profileDAO.getProfile()
        
        forenameTextField.text = profile.forename
        surnameTextField.text = profile.surname
        employeeIdTextField.text = profile.employeeId
        hoursPerWeekTextField.text = profile.hoursPerWeek
        vacationTextField.text = profile.vacation
    }
    
    
    @IBAction func done(sender: AnyObject)
    {
        let profile = Profile()
        profile.forename = forenameTextField.text
        profile.surname = surnameTextField.text
        profile.employeeId = employeeIdTextField.text
        profile.hoursPerWeek = hoursPerWeekTextField.text
        profile.vacation = vacationTextField.text
        profileDAO.setProfile(profile)
        
        dismissViewControllerAnimated(true, completion: {})
    }
    
    
    @IBAction func cancel(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: {})
    }
}

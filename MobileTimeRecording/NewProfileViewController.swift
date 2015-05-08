//
//  NewProfileViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 02/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


class NewProfileViewController: UITableViewController
{
    @IBOutlet weak var forenameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var employeeIdTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    
    /*
        Function is called when pressing 'done'-button. Creates new profile and delegates registration feedback
        back to view controller.
        
        @methodtype Command
        @pre Valid ProfileDAO singleton, view controller must implement delegate protocol
        @post New profile is created, delegate back to view controller
    */
    @IBAction func done(sender: AnyObject)
    {
        let profile = Profile(forename: forenameTextField.text, surname: surnameTextField.text, employeeId: employeeIdTextField.text)
        profileDAO.setProfile(profile)
        performSegueWithIdentifier("main_segue", sender: nil)
    }
    
    
    @IBAction func forenameChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    @IBAction func surnameChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    @IBAction func employeeIdChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    /*
        Function for enabling 'done'-button. If necessary text field are filled, button will be enabled.
        
        @methodtype Command
        @pre Text field are not empty
        @post Button will be enabled
    */
    func refreshDoneButtonState()
    {
        if !forenameTextField.text.isEmpty && !surnameTextField.text.isEmpty && !employeeIdTextField.text.isEmpty
        {
            doneButton.enabled = true
        }
        else
        {
            doneButton.enabled = false
        }
    }
}

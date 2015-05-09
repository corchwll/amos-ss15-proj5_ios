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
        iOS listener function. Called when pressing 'done'-button, creating new profile.
        
        @methodtype Command
        @pre Valid ProfileDAO singleton
        @post Initial user profile is created
    */
    @IBAction func done(sender: AnyObject)
    {
        let profile = Profile(forename: forenameTextField.text, surname: surnameTextField.text, employeeId: employeeIdTextField.text)
        profileDAO.setProfile(profile)
        performSegueWithIdentifier("main_segue", sender: nil)
    }
    
    
    /*
        iOS listener function. Called when editing forename, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func forenameChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    /*
        
        iOS listener function. Called when editing surname, refreshes 'done'-button state.
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func surnameChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    /*
        iOS listener function. Called when editing employee id, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func employeeIdChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    /*
        Function for enabling 'done'-button. Button will be enabled when all mandatory text fiels are filled.
        
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

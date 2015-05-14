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
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var employeeIdTextField: UITextField!
    @IBOutlet weak var weeklyWorkingTimeTextField: UITextField!
    @IBOutlet weak var totalVacationTimeTextField: UITextField!
    @IBOutlet weak var currentVacationTimeTextField: UITextField!
    @IBOutlet weak var currentOvertimeTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    
    /*
        iOS listener function. Called when pressing 'done'-button, creating new profile.
        
        @methodtype Command
        @pre Valid ProfileDAO singleton
        @post Initial user profile is created
    */
    @IBAction func done(sender: AnyObject)
    {
        let profile = Profile(firstname: firstnameTextField.text, lastname: lastnameTextField.text, employeeId: employeeIdTextField.text, weeklyWorkingTime: weeklyWorkingTimeTextField.text, totalVacationTime: totalVacationTimeTextField.text, currentVacationTime: currentVacationTimeTextField.text, currentOvertime: currentOvertimeTextField.text)
        profileDAO.setProfile(profile)
        performSegueWithIdentifier("main_segue", sender: nil)
    }
    
    
    /*
        iOS listener function. Called when editing firstname, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func firstnameChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    /*
        
        iOS listener function. Called when editing lastname, refreshes 'done'-button state.
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func lastnameChanged(sender: AnyObject)
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
        iOS listener function. Called when editing weekly working time, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func weeklyWorkingTimeChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    /*
        iOS listener function. Called when editing total vacation time, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func totalVacationTimeChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    /*
        iOS listener function. Called when editing current vacation time, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func currentVacationTimeChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
   
    
    /*
        iOS listener function. Called when editing current overtime, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func currentOvertimeChanged(sender: AnyObject)
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
        var isEmpty = false
        
        isEmpty = isEmpty || firstnameTextField.text.isEmpty
        isEmpty = isEmpty || lastnameTextField.text.isEmpty
        isEmpty = isEmpty || employeeIdTextField.text.isEmpty
        isEmpty = isEmpty || weeklyWorkingTimeTextField.text.isEmpty
        isEmpty = isEmpty || totalVacationTimeTextField.text.isEmpty
        isEmpty = isEmpty || currentVacationTimeTextField.text.isEmpty
        isEmpty = isEmpty || currentOvertimeTextField.text.isEmpty
        
        doneButton.enabled = !isEmpty
    }
}

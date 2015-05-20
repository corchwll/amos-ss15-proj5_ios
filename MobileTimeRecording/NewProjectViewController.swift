//
//  NewProjectViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 27/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


protocol NewProjectDelegate
{
    func didAddNewProject()
}


class NewProjectViewController: UIViewController
{
    @IBOutlet weak var projectIdTextField: UITextField!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var projectFinalDateTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var delegate: NewProjectDelegate!
    let datePicker = UIDatePicker()
    let dateFormatter = NSDateFormatter()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpDateFormatter()
        setUpDatePickerInputView()
    }
    
    
    func setUpDateFormatter()
    {
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    
    func setUpDatePickerInputView()
    {
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: Selector("datePickerDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        projectFinalDateTextField.inputView = datePicker
    }
    
    
    func datePickerDidChange()
    {
        projectFinalDateTextField.text = dateFormatter.stringFromDate(datePicker.date)
        refreshDoneButtonState()
    }
    
    
    /*
        iOS listener function. Called when editing project id, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func projectIdTimeChanged(sender: AnyObject)
    {
        if Project.isValidId(projectIdTextField.text)
        {
            projectIdTextField.textColor = UIColor.blackColor()
            refreshDoneButtonState()
        }
        else
        {
            projectIdTextField.textColor = UIColor.redColor()
        }
    }
    
    
    /*
        iOS listener function. Called when editing project name, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func projectNameChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    /*
        iOS listener function. Called when editing project final date, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func projectFinalDateChanged(sender: AnyObject)
    {
        projectFinalDateTextField.text = dateFormatter.stringFromDate(datePicker.date)
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
        
        isEmpty = isEmpty || projectIdTextField.text.isEmpty
        isEmpty = isEmpty || projectNameTextField.text.isEmpty
        isEmpty = isEmpty || projectFinalDateTextField.text.isEmpty
    
        doneButton.enabled = !isEmpty
    }
    
    
    /*
        Called when new project should be added. Stores new project into sqlite database by using
        project data access object.
    
        @methodtype Command
        @pre Valid user input
        @post New project added and current view dismissed
    */
    @IBAction func addProject(sender: AnyObject)
    {
        let newProject = Project(id: projectIdTextField.text, name: projectNameTextField.text, finalDate: dateFormatter.dateFromString(projectFinalDateTextField.text)!)
        projectDAO.addProject(newProject)
        delegate.didAddNewProject()
        
        dismissViewControllerAnimated(true, completion: {})
    }
    
    
    /*
        iOS listener function. Called when pressing 'cancel'-button, dismissing current view.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

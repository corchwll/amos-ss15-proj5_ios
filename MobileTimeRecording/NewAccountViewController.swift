//
//  NewAccountViewController.swift
//  MobileTimeRecording
//
//  Created by cdan on 02/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


protocol NewAccountViewControllerDelegate
{
    func didRegister()
}


class NewAccountViewController: UITableViewController
{
    @IBOutlet weak var forenameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var employeeIdTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var delegate: NewAccountViewControllerDelegate?
    
    
    @IBAction func done(sender: AnyObject)
    {
        delegate?.didRegister()
        dismissViewControllerAnimated(true, completion: {})
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

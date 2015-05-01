//
//  NewProjectViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 27/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


class NewProjectViewController: UIViewController
{
    @IBOutlet weak var projectIdTextField: UITextField!
    @IBOutlet weak var projectNameTextField: UITextField!
    
    
    /*
        Called when new project should be added. Stores new project into sqlite database by using
        project data access object.
    
        @methodtype Command
        @pre Valid user input
        @post New project added and current view dismissed
    */
    @IBAction func addProject(sender: AnyObject)
    {
        let newProject = Project(id: projectIdTextField.text.toInt()!, name: projectNameTextField.text)
        projectDAO.addProject(newProject)
        
        navigationController?.popViewControllerAnimated(true)
    }
}

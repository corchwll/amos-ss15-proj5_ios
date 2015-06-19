/*
    Mobile Time Accounting
    Copyright (C) 2015

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import UIKit


protocol NewProjectDelegate
{
    func didAddNewProject()
}


class NewProjectTableViewController: UITableViewController
{
    @IBOutlet weak var projectIdTextField: UITextField!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var projectFinalDateTextField: UITextField!
    @IBOutlet weak var projectLatitudeTextField: UITextField!
    @IBOutlet weak var projectLongitudeTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var delegate: NewProjectDelegate!
    let datePicker = UIDatePicker()
    let dateFormatter = NSDateFormatter()
    
    
    /*
        iOS life-cycle function, called when view did load. Sets up date formatter and input view for date picker.
        
        @methodtype Hook
        @pre -
        @post -
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpDateFormatter()
        setUpDatePickerInputView()
        refreshDoneButtonState()
    }
    
    
    /*
        Function is called to set up date formatter.
        
        @methodtype Command
        @pre -
        @post Date formatter has been set up
    */
    func setUpDateFormatter()
    {
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    
    /*
        Function is called to set up date picker input view.
        
        @methodtype Command
        @pre -
        @post Input view has been set up
    */
    func setUpDatePickerInputView()
    {
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: Selector("datePickerDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        projectFinalDateTextField.inputView = datePicker
    }
    
    
    /*
        Function is called when date picker has changed. Sets text field to selected date.
        
        @methodtype Hook
        @pre -
        @post Final date text field has been set to selected date
    */
    func datePickerDidChange()
    {
        projectFinalDateTextField.text = dateFormatter.stringFromDate(datePicker.date)
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
        let newProject = Project(id: projectIdTextField.text, name: projectNameTextField.text, finalDate: dateFormatter.dateFromString(projectFinalDateTextField.text), latitude: projectLatitudeTextField.text.toDouble(), longitude: projectLongitudeTextField.text.toDouble())

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

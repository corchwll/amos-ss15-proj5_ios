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
        if Profile.isValidId(employeeIdTextField.text)
        {
            employeeIdTextField.textColor = UIColor.blackColor()
            refreshDoneButtonState()
        }
        else
        {
            employeeIdTextField.textColor = UIColor.redColor()
        }
    }

    
    /*
        iOS listener function. Called when editing weekly working time, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func weeklyWorkingTimeChanged(sender: AnyObject)
    {
        if Profile.isValidWeeklyWorkingTime(weeklyWorkingTimeTextField.text)
        {
            weeklyWorkingTimeTextField.textColor = UIColor.blackColor()
            refreshDoneButtonState()
        }
        else
        {
            weeklyWorkingTimeTextField.textColor = UIColor.redColor()
            doneButton.enabled = false
        }
    }
    
    
    /*
        iOS listener function. Called when editing total vacation time, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func totalVacationTimeChanged(sender: AnyObject)
    {
        if Profile.isValidTotalVacationTime(totalVacationTimeTextField.text)
        {
            totalVacationTimeTextField.textColor = UIColor.blackColor()
            refreshDoneButtonState()
        }
        else
        {
            totalVacationTimeTextField.textColor = UIColor.redColor()
            doneButton.enabled = false
        }
    }
    
    
    /*
        iOS listener function. Called when editing current vacation time, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func currentVacationTimeChanged(sender: AnyObject)
    {
        if Profile.isValidCurrentVacationTime(currentVacationTimeTextField.text)
        {
            currentVacationTimeTextField.textColor = UIColor.blackColor()
            refreshDoneButtonState()
        }
        else
        {
            currentVacationTimeTextField.textColor = UIColor.redColor()
            doneButton.enabled = false
        }
    }
   
    
    /*
        iOS listener function. Called when editing current overtime, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func currentOvertimeChanged(sender: AnyObject)
    {
        if Profile.isValidCurrentOvertime(currentOvertimeTextField.text)
        {
            currentOvertimeTextField.textColor = UIColor.blackColor()
            refreshDoneButtonState()
        }
        else
        {
            currentOvertimeTextField.textColor = UIColor.redColor()
            doneButton.enabled = false
        }
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

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


protocol NewProfileViewControllerDelegate
{
    func didRegisterProfile()
}


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
    
    var delegate: NewProfileViewControllerDelegate!
    var validId = false
    var validWeeklyWorkingTime = false
    var validTotalVacationTime = false
    var validCurrentVacationTime = false
    var validOvertime = false
    
    
    /*
        iOS listener function. Called when pressing 'done'-button, creating new profile.
        
        @methodtype Command
        @pre Valid ProfileDAO singleton
        @post Initial user profile is created
    */
    @IBAction func done(sender: AnyObject)
    {
        setUserProfile()
        delegate.didRegisterProfile()
    }
    
    
    func setUserProfile()
    {
        let firstname = firstnameTextField.text
        let lastname = lastnameTextField.text
        let employeeId = employeeIdTextField.text
        let weeklyWorkingTime = weeklyWorkingTimeTextField.text.toInt()!
        let totalVacationTime = totalVacationTimeTextField.text.toInt()!
        let currentVacationTime = currentVacationTimeTextField.text.toInt()!
        let currentOvertime = currentOvertimeTextField.text.toInt()!
        let registrationDate = NSDate()
        
        let profile = Profile(firstname: firstname, lastname: lastname, employeeId: employeeId, weeklyWorkingTime: weeklyWorkingTime, totalVacationTime: totalVacationTime, currentVacationTime: currentVacationTime, currentOvertime: currentOvertime, registrationDate: registrationDate)
        profileDAO.setProfile(profile)
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
            validId = true
        }
        else
        {
            employeeIdTextField.textColor = UIColor.redColor()
            validId = false
        }
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
        if Profile.isValidWeeklyWorkingTime(weeklyWorkingTimeTextField.text)
        {
            weeklyWorkingTimeTextField.textColor = UIColor.blackColor()
            validWeeklyWorkingTime = true
        }
        else
        {
            weeklyWorkingTimeTextField.textColor = UIColor.redColor()
            validWeeklyWorkingTime = false
        }
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
        if Profile.isValidTotalVacationTime(totalVacationTimeTextField.text)
        {
            totalVacationTimeTextField.textColor = UIColor.blackColor()
            validTotalVacationTime = true
        }
        else
        {
            totalVacationTimeTextField.textColor = UIColor.redColor()
            validTotalVacationTime = false
        }
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
        if Profile.isValidCurrentVacationTime(currentVacationTimeTextField.text)
        {
            currentVacationTimeTextField.textColor = UIColor.blackColor()
            validCurrentVacationTime = true
        }
        else
        {
            currentVacationTimeTextField.textColor = UIColor.redColor()
            validCurrentVacationTime = false
        }
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
        if Profile.isValidCurrentOvertime(currentOvertimeTextField.text)
        {
            currentOvertimeTextField.textColor = UIColor.blackColor()
            validOvertime = true
        }
        else
        {
            currentOvertimeTextField.textColor = UIColor.redColor()
            validOvertime = false
        }
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
        var isValid = true
        
        isValid = isValid && !firstnameTextField.text.isEmpty
        isValid = isValid && !lastnameTextField.text.isEmpty
        isValid = isValid && validId
        isValid = isValid && validWeeklyWorkingTime
        isValid = isValid && validTotalVacationTime
        isValid = isValid && validCurrentVacationTime
        isValid = isValid && validOvertime
        
        doneButton.enabled = isValid
    }
}

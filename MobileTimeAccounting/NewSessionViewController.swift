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


class NewSessionViewController: UITableViewController
{
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectIdLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    
    let timeFormatter = NSDateFormatter()
    let dateFormatter = NSDateFormatter()
    var datePicker = UIDatePicker()
    var timePickerFrom = UIDatePicker()
    var timePickerTo = UIDatePicker()
    
    var session = Session()
    var project: Project!
    
    
    /*
        iOS life-cycle function. Setting up current session and ui.
        
        @methodtype Hook
        @pre -
        @post Current session and ui is set up
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpProjectHeading()
        setUpDateTimeFormatters()
        setUpSession()
        setUpTimeTextFields()
    }
    
    
    /*
        Function is setting up project heading for ui.
        
        @methodtype Command
        @pre Valid project has been set
        @post Ui for project heading is set up
    */
    func setUpProjectHeading()
    {
        projectNameLabel.text = project.name
        projectIdLabel.text = String(project.id)
    }
    
    
    /*
        Function is setting up date/time formatters.
        
        @methodtype Command
        @pre Valid and initialized formatter objects
        @post Date and time formatters are set up
    */
    func setUpDateTimeFormatters()
    {
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        timeFormatter.locale = NSLocale(localeIdentifier: "en_DE")
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    
    /*
        Function is setting up new session.
        
        @methodtype Command
        @pre Valid session object
        @post Session has been set up
    */
    func setUpSession()
    {
        session.startTime = timeFormatter.dateFromString("08:00")!
        session.endTime = timeFormatter.dateFromString("16:00")!
    }
    
    
    /*
        Function is setting up ui for date and time.
        
        @methodtype Command
        @pre Date and time formatters are set up
        @post Ui for date and time has been set up
    */
    func setUpTimeTextFields()
    {
        dateTextField.text = dateFormatter.stringFromDate(NSDate())
        fromTextField.text = timeFormatter.stringFromDate(session.startTime)
        toTextField.text = timeFormatter.stringFromDate(session.endTime)
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: Selector("datePickerDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        dateTextField.inputView = datePicker
        
        timePickerFrom.datePickerMode = UIDatePickerMode.Time
        timePickerFrom.minuteInterval = 30
        timePickerFrom.locale = NSLocale(localeIdentifier: "en_DE")
        timePickerFrom.addTarget(self, action: Selector("timePickerFromDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        timePickerFrom.date = session.startTime
        fromTextField.inputView = timePickerFrom
        
        timePickerTo.datePickerMode = UIDatePickerMode.Time
        timePickerTo.minuteInterval = 30
        timePickerTo.locale = NSLocale(localeIdentifier: "en_DE")
        timePickerTo.addTarget(self, action: Selector("timePickerToDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        timePickerTo.date = session.endTime
        toTextField.inputView = timePickerTo
    }
    
    
    /*
        Listener function for date picker. Updating session date.
        
        @methodtype Hook
        @pre -
        @post -
    */
    func datePickerDidChange()
    {
        dateTextField.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    
    /*
        Listener function for start time picker. Updating session start time.
        
        @methodtype Hook
        @pre -
        @post -
    */
    func timePickerFromDidChange()
    {
        fromTextField.text = timeFormatter.stringFromDate(timePickerFrom.date)
        updateDoneButtonState()
    }
    
    
    /*
        Listener function for end time picker. Updating session end time.    
        
        @methodtype Hook
        @pre -
        @post -
    */
    func timePickerToDidChange()
    {
        toTextField.text = timeFormatter.stringFromDate(timePickerTo.date)
        updateDoneButtonState()
    }
    
    
    /*
        Function is updating status of 'done'-button.
        
        @methodtype Command
        @pre Start time must be lower than end time
        @post 'done'-button enabled else disabled
    */
    func updateDoneButtonState()
    {
        if timePickerFrom.date.timeIntervalSince1970 > timePickerTo.date.timeIntervalSince1970
        {
            doneButton.enabled = false
        }
        else
        {
            doneButton.enabled = true
        }
    }
    
    
    /*
        Function is called when pressing the 'add'-button. Creates a new session by using user input and data access object.
        
        @methodtype Command
        @pre Valid SessionDAO singleton
        @post New session, stored into database
    */
    @IBAction func addNewSession(sender: AnyObject)
    {
        var calendar = NSCalendar.currentCalendar()
        var dateComponent = calendar.components(.CalendarUnitTimeZone | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: dateFormatter.dateFromString(dateTextField.text)!)
        var fromTimeComponent = calendar.components(.CalendarUnitTimeZone | .CalendarUnitHour | .CalendarUnitMinute, fromDate: timeFormatter.dateFromString(fromTextField.text)!)
        var toTimeComponent = calendar.components(.CalendarUnitTimeZone | .CalendarUnitHour | .CalendarUnitMinute, fromDate: timeFormatter.dateFromString(toTextField.text)!)
        
        fromTimeComponent.day = dateComponent.day
        fromTimeComponent.month = dateComponent.month
        fromTimeComponent.year = dateComponent.year
        
        toTimeComponent.day = dateComponent.day
        toTimeComponent.month = dateComponent.month
        toTimeComponent.year = dateComponent.year
        
        session.startTime = calendar.dateFromComponents(fromTimeComponent)!
        session.endTime = calendar.dateFromComponents(toTimeComponent)!
        
        if sessionManager.addSession(session, project: project)
        {
            self.dismissViewControllerAnimated(true, completion: {})
        }
    }
    
    
    /*
        Function is called when pressing the 'cancel'-button. Dismisses the current view controller and returns to recording.
        
        @methodtype Command
        @pre -
        @post Dismiss view controller
    */
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

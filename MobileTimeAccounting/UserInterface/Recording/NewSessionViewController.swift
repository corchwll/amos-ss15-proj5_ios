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


protocol NewSessionDelegate
{
    func didAddNewSession()
}


class NewSessionViewController: UITableViewController
{
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectIdLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var dateWarningLabel: UILabel!

    let DefaultStartTime = NSDate(hour: 8, minute: 0, second: 0, day: 0, month: 0, year: 0, calendar: NSCalendar.currentCalendar())
    let DefaultEndTime = NSDate(hour: 16, minute: 0, second: 0, day: 0, month: 0, year: 0, calendar: NSCalendar.currentCalendar())
    
    var delegate: NewSessionDelegate!
    let timeFormatter = NSDateFormatter()
    let dateFormatter = NSDateFormatter()
    var datePicker = UIDatePicker()
    var timePickerFrom = UIDatePicker()
    var timePickerTo = UIDatePicker()
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
        setUpTimeFormatter()
        setUpDateFormatter()
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
        projectIdLabel.text = project.id
    }
    
    
    /*
        Function is setting up time formatter.
        
        @methodtype Command
        @pre Initialized formatter object
        @post Time formatters is set up
    */
    func setUpTimeFormatter()
    {
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        timeFormatter.locale = NSLocale(localeIdentifier: "en_DE")
    }
    
    
    /*
        Function is setting up date formatter.
        
        @methodtype Command
        @pre Initialized formatter object
        @post Date formatters is set up
    */
    func setUpDateFormatter()
    {
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    
    /*
        Function is setting up ui for date and time.
        
        @methodtype Command
        @pre Date and time formatters are set up
        @post Ui for date and time has been set up
    */
    func setUpTimeTextFields()
    {
        setUpDateTextField()
        setUpStartTimeTextField()
        setUpEndTimeTextField()
    }
    
    
    /*
        Sets up date text field by using current date and setting input view.
        
        @methodtype Command
        @pre Initialized date picker object
        @post Date text field is set up
    */
    func setUpDateTextField()
    {
        setDate(NSDate())
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: Selector("datePickerDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        dateTextField.inputView = datePicker
    }
    
    
    /*
        Sets date to date text field. If date is a holiday, saturday or sunday a warning is shown.
        
        @methodtype Command
        @pre -
        @post Date is set
    */
    func setDate(date: NSDate)
    {
        dateTextField.text = dateFormatter.stringFromDate(date)
        
        if date.isHoliday()
        {
            dateWarningLabel.text = "*Day is a Holiday"
            dateWarningLabel.hidden = false
        }
        else if date.isSaturday()
        {
            dateWarningLabel.text = "*Day is a Saturday"
            dateWarningLabel.hidden = false
        }
        else if date.isSunday()
        {
            dateWarningLabel.text = "*Day is a Sunday"
            dateWarningLabel.hidden = false
        }
        else
        {
            dateWarningLabel.hidden = true
        }
    }
    
    
    /*
        Listener function for date picker. Updating session date.
        
        @methodtype Hook
        @pre -
        @post Date is set
    */
    func datePickerDidChange()
    {
        setDate(datePicker.date)
    }
    
    
    /*
        Sets up start time text field along with input view.
        
        @methodtype Command
        @pre Initialized time picker
        @post Start time text field is set up
    */
    func setUpStartTimeTextField()
    {
        timePickerFrom.datePickerMode = UIDatePickerMode.Time
        timePickerFrom.minuteInterval = 30
        timePickerFrom.locale = NSLocale(localeIdentifier: "en_DE")
        timePickerFrom.addTarget(self, action: Selector("timePickerFromDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        timePickerFrom.date = DefaultStartTime
        
        fromTextField.inputView = timePickerFrom
        fromTextField.text = timeFormatter.stringFromDate(DefaultStartTime)
    }
    
    
    /*
        Listener function for start time picker. Updating session start time.
        
        @methodtype Hook
        @pre -
        @post Time is set
    */
    func timePickerFromDidChange()
    {
        fromTextField.text = timeFormatter.stringFromDate(timePickerFrom.date)
        updateDoneButtonState()
    }
    
    
    /*
        Sets up end time text field along with input view.
        
        @methodtype Command
        @pre Initialized time picker
        @post End time text field is set up
    */
    func setUpEndTimeTextField()
    {
        timePickerTo.datePickerMode = UIDatePickerMode.Time
        timePickerTo.minuteInterval = 30
        timePickerTo.locale = NSLocale(localeIdentifier: "en_DE")
        timePickerTo.addTarget(self, action: Selector("timePickerToDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        timePickerTo.date = DefaultEndTime
        
        toTextField.inputView = timePickerTo
        toTextField.text = timeFormatter.stringFromDate(DefaultEndTime)
    }
    
    
    /*
        Listener function for end time picker. Updating session end time.    
        
        @methodtype Hook
        @pre -
        @post End time is set
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
        @post New session is stored into database
    */
    @IBAction func addNewSession(sender: AnyObject)
    {
        let session = getSessionFromTextFields()
        if sessionManager.addSession(session, project: project)
        {
            self.dismissViewControllerAnimated(true, completion: {})
            delegate.didAddNewSession()
        }
    }
    
    
    /*
        Returns new session by using all input values and merge them together into one session object.
        
        @methodtype Getter
        @pre -
        @post Returns new session object
    */
    func getSessionFromTextFields() -> Session
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
        
        return Session(startTime: calendar.dateFromComponents(fromTimeComponent)!, endTime: calendar.dateFromComponents(toTimeComponent)!)
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

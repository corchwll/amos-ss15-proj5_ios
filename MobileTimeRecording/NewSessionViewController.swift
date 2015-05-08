//
//  NewSessionViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 30/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

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
        iOS life-cycle function, called when view did load. Start and end-time is set to default values.
        
        @methodtype Hook
        @pre -
        @post Set default time values
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpProjectHeading()
        setUpDateTimeFormatters()
        setUpSession()
        setUpTimeTextFields()
    }
    
    
    func setUpProjectHeading()
    {
        projectNameLabel.text = project.name
        projectIdLabel.text = String(project.id)
    }
    
    
    func setUpDateTimeFormatters()
    {
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        timeFormatter.locale = NSLocale(localeIdentifier: "en_DE")
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    
    func setUpSession()
    {
        session.startTime = timeFormatter.dateFromString("08:00")!
        session.endTime = timeFormatter.dateFromString("16:00")!
    }
    
    
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
    
    
    func datePickerDidChange()
    {
        dateTextField.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    
    func timePickerFromDidChange()
    {
        fromTextField.text = timeFormatter.stringFromDate(timePickerFrom.date)
        updateDoneButtonState()
    }
    
    
    func timePickerToDidChange()
    {
        toTextField.text = timeFormatter.stringFromDate(timePickerTo.date)
        updateDoneButtonState()
    }
    
    
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
        var fromTimeComponent = calendar.components(.CalendarUnitTimeZone | .CalendarUnitHour | .CalendarUnitMinute, fromDate: session.startTime)
        var toTimeComponent = calendar.components(.CalendarUnitTimeZone | .CalendarUnitHour | .CalendarUnitMinute, fromDate: session.endTime)
        
        fromTimeComponent.day = dateComponent.day
        fromTimeComponent.month = dateComponent.month
        fromTimeComponent.year = dateComponent.year
        
        toTimeComponent.day = dateComponent.day
        toTimeComponent.month = dateComponent.month
        toTimeComponent.year = dateComponent.year
        
        sessionDAO.addSession(session, project: project!)
        self.dismissViewControllerAnimated(true, completion: {})
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

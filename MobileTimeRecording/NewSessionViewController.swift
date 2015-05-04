//
//  NewSessionViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 30/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


class NewSessionViewController: UITableViewController, FromViewControllerDelegate, ToViewControllerDelegate
{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!
    
    var timeFormatter = NSDateFormatter()
    var session = Session()
    var project: Project?
    
    
    /*
        iOS life-cycle function, called when view did load. Start and end-time is set to default values.
        
        @methodtype Hook
        @pre -
        @post Set default time values
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        timeFormatter.dateFormat = "HH:mm"
        
        session.startTime = timeFormatter.dateFromString("08:00")!
        session.endTime = timeFormatter.dateFromString("16:00")!
        
        fromTimeLabel.text = timeFormatter.stringFromDate(session.startTime)
        toTimeLabel.text = timeFormatter.stringFromDate(session.endTime)
    }
    
    
    /*
        iOS life-cycle function, called right before performing a segue.
        
        @methodtype Hook
        @pre Valid segue identifier
        @post Set delegates for future callbacks
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "from_segue"
        {
            var destination = segue.destinationViewController as! FromViewController
            destination.delegate = self
        }
        else
        {
            var destination = segue.destinationViewController as! ToViewController
            destination.delegate = self
        }
    }

    
    /*
        Callback function, called when start-time is picked.
        
        @methodtype Hook
        @pre -
        @post Notify controller, set start-time
    */
    func pickedFromTime(time: NSDate)
    {
        fromTimeLabel.text = timeFormatter.stringFromDate(time)
        session.startTime = time
    }
    
    
    /*
        Callback function, called when end-time is picked.
        
        @methodtype Hook
        @pre -
        @post Notify controller, set end-time
    */
    func pickedToTime(time: NSDate)
    {
        toTimeLabel.text = timeFormatter.stringFromDate(time)
        session.endTime = time
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
        var dateComponent = calendar.components(.CalendarUnitTimeZone | .CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: datePicker.date)
        var fromTimeComponent = datePicker.calendar.components(.CalendarUnitTimeZone | .CalendarUnitHour | .CalendarUnitMinute, fromDate: session.startTime)
        var toTimeComponent = datePicker.calendar.components(.CalendarUnitTimeZone | .CalendarUnitHour | .CalendarUnitMinute, fromDate: session.endTime)
        
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

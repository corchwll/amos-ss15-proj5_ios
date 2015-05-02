//
//  NewSessionViewController.swift
//  MobileTimeRecording
//
//  Created by cdan on 30/04/15.
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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        timeFormatter.dateFormat = "HH:mm"
        
        session.startTime = timeFormatter.dateFromString("08:00")!
        session.endTime = timeFormatter.dateFromString("16:00")!
        
        fromTimeLabel.text = timeFormatter.stringFromDate(session.startTime)
        toTimeLabel.text = timeFormatter.stringFromDate(session.endTime)
    }
    
    
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

    
    func pickedFromTime(time: NSDate)
    {
        fromTimeLabel.text = timeFormatter.stringFromDate(time)
        session.startTime = time
    }
    
    
    func pickedToTime(time: NSDate)
    {
        toTimeLabel.text = timeFormatter.stringFromDate(time)
        session.endTime = time
    }
    
    
    @IBAction func addNewSession(sender: AnyObject)
    {
        var calendar = NSCalendar.currentCalendar()
        var dateComponent = calendar.components(.TimeZoneCalendarUnit | .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit, fromDate: datePicker.date)
        var fromTimeComponent = datePicker.calendar.components(.TimeZoneCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit, fromDate: session.startTime)
        var toTimeComponent = datePicker.calendar.components(.TimeZoneCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit, fromDate: session.endTime)
        
        fromTimeComponent.day = dateComponent.day
        fromTimeComponent.month = dateComponent.month
        fromTimeComponent.year = dateComponent.year
        
        toTimeComponent.day = dateComponent.day
        toTimeComponent.month = dateComponent.month
        toTimeComponent.year = dateComponent.year
        
        sessionDAO.addSession(session, project: project!)
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

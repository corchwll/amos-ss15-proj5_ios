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
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!
    
    var timeFormatter = NSDateFormatter()
    var fromTime: NSDate?
    var toTime: NSDate?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timeFormatter.dateFormat = "HH:mm"
        fromTime = timeFormatter.dateFromString("08:00")
        toTime = timeFormatter.dateFromString("16:00")
        
        fromTimeLabel.text = timeFormatter.stringFromDate(fromTime!)
        toTimeLabel.text = timeFormatter.stringFromDate(toTime!)
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
        fromTime = time
    }
    
    
    func pickedToTime(time: NSDate)
    {
        toTimeLabel.text = timeFormatter.stringFromDate(time)
        toTime = time
    }
}

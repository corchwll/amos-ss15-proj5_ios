//
//  FromViewController.swift
//  MobileTimeRecording
//
//  Created by cdan on 02/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


protocol FromViewControllerDelegate
{
    func pickedFromTime(time: NSDate)
}


class FromViewController: UIViewController
{
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    var delegate: FromViewControllerDelegate?
    
    
    @IBAction func done(sender: AnyObject)
    {
        if delegate != nil
        {
            var fromTime = fromDatePicker.date
            delegate?.pickedFromTime(fromTime)
            navigationController?.popViewControllerAnimated(true)
        }
    }
}

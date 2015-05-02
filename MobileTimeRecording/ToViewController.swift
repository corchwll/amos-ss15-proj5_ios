//
//  ToViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 02/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


protocol ToViewControllerDelegate
{
    func pickedToTime(time: NSDate)
}


class ToViewController: UIViewController
{
    @IBOutlet weak var toDatePicker: UIDatePicker!
    var delegate: ToViewControllerDelegate?


    @IBAction func done(sender: AnyObject)
    {
        if delegate != nil
        {
            var fromTime = toDatePicker.date
            delegate?.pickedToTime(fromTime)
            navigationController?.popViewControllerAnimated(true)
        }
    }
}

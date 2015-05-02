//
//  FromViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 02/05/15.
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
    
    
    /*
        Function is called when pressing 'done'-button. Delegates user input back to session controller
        and dismisses this view.
        
        @methodtype Hook
        @pre Valid segue identifier
        @post Set delegates for future callbacks
    */
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

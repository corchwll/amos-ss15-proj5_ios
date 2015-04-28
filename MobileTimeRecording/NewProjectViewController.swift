//
//  NewProjectViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 27/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


class NewProjectViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

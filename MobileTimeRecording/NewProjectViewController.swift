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
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

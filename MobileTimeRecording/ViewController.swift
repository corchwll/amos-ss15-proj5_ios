//
//  ViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 20/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet var timeLabel: UILabel!
    var timer : NSTimer!
    var elapsedTime = 0
    
    
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

    
    /*
        Function is called when pressing play button.
        Starts the time recording thread, visualizing the timer.
        
        @methodtype
        @pre
        @post
    */
    @IBAction func startTimeRecording(sender: AnyObject)
    {
        if(self.timer == nil)
        {
            timeLabel.text = formatTimeToString(0)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        }
        else
        {
            timer.invalidate()
            timer = nil
            elapsedTime = 0
        }
    }
    
    
    /*
        Update function for timer, called every time interval.
    
        @methodtype command
        @pre Initialized thread object
        @post Thread is running
    */
    func updateTimer()
    {
        elapsedTime += 1
        timeLabel.text = formatTimeToString(elapsedTime)
    }
    
    
    /*
        Formats a given time interval to its string representation e.g.
        128 -> 2 m 08 s
    
        @methodtype convert
        @pre Time interval in seconds
        @post Converted string, representing the time
    */
    func formatTimeToString(elapsedTime : Int) -> String
    {
        var minutes = elapsedTime/60
        var seconds = elapsedTime%60
        
        var secondsString = ""
        var minutesString = ""
        
        if (seconds/10 == 0)
        {
            secondsString = "0\(seconds)"
        }
        else
        {
            secondsString = "\(seconds)"
        }
        minutesString = "\(minutes)"
        
        return minutesString + " m " + secondsString + " s"
    }
}


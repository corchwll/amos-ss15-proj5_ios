//
//  RecordingViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 20/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


class RecordingViewController: UIViewController, NewProfileViewControllerDelegate
{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var projectIdLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!


    var timer : NSTimer!
    var project: Project!
    var session: Session = Session()
    var isRunning: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        performOneTimeRegistration()
    }
    
    
    /*
        Function for user registration. Will perform an initial registration screen for creating a profile.
        
        @methodtype Command
        @pre User not yet registered
        @post Perform segue for registration
    */
    func performOneTimeRegistration()
    {
        var nsUserDefaults = NSUserDefaults()
        if !nsUserDefaults.boolForKey("registered")
        {
            performSegueWithIdentifier("new_account_segue", sender: self)
        }
        else
        {
            //debug: prints user account
            println(profileDAO.getProfile().asString())
        }
    }
    
    
    func setProject(project: Project)
    {
        self.project = project
        projectIdLabel.text = String(project.id)
        projectNameLabel.text = project.name
    }
    
    
    /*
        iOS life-cycle function, called right before performing a segue.
        
        @methodtype Hook
        @pre Valid segue identifier
        @post Set delegates for future callbacks
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "new_session_segue"
        {
            var viewController = segue.destinationViewController as! NewSessionViewController
            viewController.project = project
        }
        else if segue.identifier == "new_account_segue"
        {
            var navigationController = segue.destinationViewController as! UINavigationController
            var viewController = navigationController.topViewController as! NewProfileViewController
            viewController.delegate = self
        }
    }
    
    
    /*
        Callback function, signalizing user profile registered. Sets boolean for one time registration.
        
        @methodtype Hook
        @pre -
        @post Set boolean to registered
    */
    func didRegister()
    {
        var nsUserDefaults = NSUserDefaults()
        nsUserDefaults.setBool(true, forKey: "registered")
    }
    
    
    /*
        Function is called when pressing play button.
        Toggles time recording functionality.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func toggleTimeRecording(sender: AnyObject)
    {
        if isRunning
        {
            session.endTime = NSDate()
            sessionDAO.addSession(session, project: project!)
        
            stopVisualizingTimer()
            isRunning = false
        }
        else
        {
            session.startTime = NSDate()
        
            startVisualizingTimer()
            isRunning = true
        }
    }
    
    
    /*
        Visualizes elapsed time on screen.
    
        @methodtype Command
        @pre -
        @post Running timer
    */
    func startVisualizingTimer()
    {
        startStopButton.setTitle("STOP", forState: .Normal)
        timeLabel.text = formatTimeToString(0)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    
    /*
        Callback function for timer.
        Updates elapsed time along with ui.
    
        @methodtype Command
        @pre -
        @post Update on ui and elapsed time
    */
    func updateTimer()
    {
        var elapsedTime = (Int(NSDate().timeIntervalSinceDate(session.startTime)))
        timeLabel.text = formatTimeToString(elapsedTime)
    }
    
    
    /*
        Stop Visualization.
    
        @methodtype Command
        @pre Valid timer object
        @post Invalidated and deleted timer
    */
    func stopVisualizingTimer()
    {
        if(timer != nil)
        {
            startStopButton.setTitle("START", forState: .Normal)
            timer.invalidate()
            timer = nil
        }
    }
    
    
    /*
        Formats a given time interval in seconds to a string representation e.g.
        128 -> 2 m 08 s
    
        @methodtype Convert
        @pre Time interval in seconds
        @post Converted string, representing the time
    */
    func formatTimeToString(elapsedTime : Int) -> String
    {
        var minutes = elapsedTime/60
        var seconds = elapsedTime%60
        
        return String(format: "%d:%0.2d", minutes, seconds)
    }
}


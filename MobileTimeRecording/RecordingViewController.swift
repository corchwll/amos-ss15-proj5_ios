//
//  RecordingViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 20/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


class RecordingViewController: UIViewController
{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var newSessionButton: UIBarButtonItem!
    @IBOutlet weak var chooseProjectButton: UIButton!
    @IBOutlet weak var projectIdLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!

    let nsUserDefaults = NSUserDefaults()
    let RECENT_PROJECT_ID_KEY = "last_project_id_key"
    
    var timer: NSTimer!
    var project: Project!
    var session: Session = Session()
    var isRunning: Bool = false
    
    
    /*
        iOS life-cycle function. Looks up recent project and handles what to do if no recent projects was found.
        
        @methodtype Hook
        @pre -
        @post -
    */
    override func viewDidLoad()
    {
        if nsUserDefaults.integerForKey(RECENT_PROJECT_ID_KEY) != 0
        {
            setButtonStateForHasProject(true)
            loadRecentProject()
            setProjectHeading()
        }
        else
        {
            setButtonStateForHasProject(false)
        }
    }
    
    
    /*
        iOS life-cycle function, called when view did appear.
        Enables/Hides all buttons based on current project situation (if a project is active or not).
        
        @methodtype Hook
        @pre -
        @post Buttons are enabled/disabled/hidden/visible
    */
    override func viewDidAppear(animated: Bool)
    {
        if let project = project
        {
            setButtonStateForHasProject(true)
            setProjectHeading()
        }
    }
    
    
    /*
        Function is setting the button status of 'start'/'stop'-button, 'new session'-button and 'choose project'-button.
        
        @methodtype Command
        @pre Buttons are available
        @post Status of buttons has been changed
    */
    func setButtonStateForHasProject(hasProject: Bool)
    {
        startStopButton.enabled = hasProject
        newSessionButton.enabled = hasProject
        chooseProjectButton.hidden = hasProject
    }
    
    
    /*
        Function is setting the heading for projects.
        
        @methodtype Command
        @pre Project must be set
        @post Heading has been set
    */
    func setProjectHeading()
    {
        if let project = project
        {
            projectIdLabel.text = String(project.id)
            projectNameLabel.text = project.name
        }
    }
    
    
    /*
        Function is loading the most recent project.
        
        @methodtype Command
        @pre There must be a recent project
        @post Recent project has been set
    */
    func loadRecentProject()
    {
        let recentProjectId = nsUserDefaults.integerForKey(RECENT_PROJECT_ID_KEY)
        setProject(projectDAO.getProject(recentProjectId))
    }
    
    
    /*
        Setting new active project, ready for recording.
        
        @methodtype Setter
        @pre -
        @post New project is set, along with recent project id
    */
    func setProject(project: Project)
    {
        self.project = project
        nsUserDefaults.setInteger(project.id, forKey: RECENT_PROJECT_ID_KEY)
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
            var navigationController = segue.destinationViewController as! UINavigationController
            var viewController = navigationController.visibleViewController as! NewSessionViewController
            viewController.project = project
        }
    }
    
    
    /*
        Function is called when pressing 'Choose project'-button.
        If this button is visible, it means that no project is currently active, switches to 'Projects'-tab.
        
        @methodtype Command
        @pre -
        @post 'Projects'-tab is active
    */
    @IBAction func chooseProjectForRecording(sender: AnyObject)
    {
        tabBarController?.selectedIndex = 1
    }
    
    
    /*
        Function is called when pressing play button.
        Toggles time recording functionality.
        
        @methodtype Command
        @pre -
        @post Time recording is toggled
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
        startStopButton.backgroundColor = UIColor.redColor()
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
            startStopButton.backgroundColor = UIColor(red: 0x00, green: 0xcc/0xff, blue: 0x66/0xff, alpha: 0xff)
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


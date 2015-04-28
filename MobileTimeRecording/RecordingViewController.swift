//
//  ViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 20/04/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit


class RecordingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var projectsList: UITableView!
    @IBOutlet weak var startStopButton: UIButton!


    var timer : NSTimer!
    var projects: [Project] = []
    var session: Session = Session()
    var isRunning: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        projects = projectDAO.getProjects()
        projectsList.reloadData()
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return projects.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: ProjectTableViewCell = projectsList.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProjectTableViewCell
        
        var project = projects[indexPath.item]
        cell.projectID.text = "\(project.id)"
        cell.projectName.text = project.name

        return cell
    }
    
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        if isRunning
        {
            return nil
        }
        else
        {
            return indexPath
        }
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
        if projectsList.indexPathForSelectedRow() != nil
        {
            if isRunning
            {
                session.endTime = NSDate()
                sessionDAO.addSession(session, project: projects[projectsList.indexPathForSelectedRow()!.item])
            
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
        
        return String(format: "%d m %0.2d s", minutes, seconds)
    }
}


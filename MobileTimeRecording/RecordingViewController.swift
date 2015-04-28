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
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var projectsList: UITableView!

    
    var projects: [Project] = []
    
    var timer : NSTimer!
    var startTime : NSDate!
    var elapsedTime = 0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        projects = projectDAO.getProjects()
        self.projectsList.reloadData()
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


    /*
        Function is called when pressing play button.
        Toggles time recording functionality.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func toggleTimeRecording(sender: AnyObject)
    {
        if(startTime == nil)
        {
            startTime = NSDate()
            startVisualizingTimer()
        }
        else
        {
            var session = Session(id: 0, startTime: startTime, endTime: NSDate())
            var project = projects[projectsList.indexPathForSelectedRow()!.item]
            sessionDAO.addSession(session, project: project)
            
            stopVisualizingTimer()
            startTime = nil
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
        elapsedTime = 0
        timeLabel.text = formatTimeToString(elapsedTime)
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
        elapsedTime += 1
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


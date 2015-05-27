/*
    Mobile Time Accounting
    Copyright (C) 2015

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import UIKit


class RecordingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var newSessionButton: UIBarButtonItem!
    @IBOutlet weak var chooseProjectButton: UIButton!
    @IBOutlet weak var projectIdLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectSessionsTableView: UITableView!
    

    let nsUserDefaults = NSUserDefaults()
    let RECENT_PROJECT_ID_KEY = "last_project_id_key"
    
    var timer: NSTimer!
    var project: Project!
    var projectSessions: [Session]!
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
        if let recentProjectId = nsUserDefaults.stringForKey(RECENT_PROJECT_ID_KEY)
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
            loadProjectSessions()
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
    
    
    func loadProjectSessions()
    {
        projectSessions = sessionDAO.getSessions(project)
        projectSessionsTableView.reloadData()
    }
    
    
    /*
        Function is loading the most recent project.
        
        @methodtype Command
        @pre There must be a recent project
        @post Recent project has been set
    */
    func loadRecentProject()
    {
        let recentProjectId = nsUserDefaults.stringForKey(RECENT_PROJECT_ID_KEY)!
        if let project = projectDAO.getProject(recentProjectId)
        {
            setProject(project)
        }
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
        nsUserDefaults.setObject(project.id, forKey: RECENT_PROJECT_ID_KEY)
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
        Function is called when populating table row cells. Project session are loaded into table view cells.
        
        @methodtype Command
        @pre Project sessions are available
        @post Session cell has been created
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: SessionTableViewCell = projectSessionsTableView.dequeueReusableCellWithIdentifier("session_cell", forIndexPath: indexPath) as! SessionTableViewCell
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_DE")
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        timeFormatter.locale = NSLocale(localeIdentifier: "en_DE")
        
        cell.sessionDate.text = dateFormatter.stringFromDate(projectSessions[indexPath.row].startTime)
        cell.sessionStartTime.text = timeFormatter.stringFromDate(projectSessions[indexPath.row].startTime) + " - " + timeFormatter.stringFromDate(projectSessions[indexPath.row].endTime)
        
        return cell
    }
    
    
    /*
        Function is called when asking the total number of cells in table view.
        
        @methodtype Command
        @pre -
        @post Session count is returned
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let projectSessions = self.projectSessions
        {
            return projectSessions.count
        }
        else
        {
            return 0
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
            loadProjectSessions()
        
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


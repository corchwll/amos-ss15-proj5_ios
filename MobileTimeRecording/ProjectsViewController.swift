//
//  ProjectsViewController.swift
//  MobileTimeRecording
//
//  Created by DanNglk on 08/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, NewProjectDelegate
{
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var alphabet = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var dictionary: Dictionary<String, [Project]>!
    var projects: [Project]!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("edit")), animated: true)
    }
    
    /*
        iOS life-cycle function. Reloading all projects into ui.
        
        @methodtype Hook
        @pre -
        @post Relaoded projects
    */
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        reloadProjects()
    }
    
    
    /*
        Function is reloading all projects into ui.
        
        @methodtype Command
        @pre -
        @post Reloaded projects
    */
    func reloadProjects()
    {
        dictionary = Dictionary<String, [Project]>()
        projects = projectDAO.getProjects()
        
        archiveProjectsIntoDictionary()
        projectsTableView.reloadData()
    }
    
    
    /*
        Function is archiving all project into a dictionary for alphabetical grouping.
        
        @methodtype Command
        @pre Initialized dictionary
        @post Archived projects
    */
    func archiveProjectsIntoDictionary()
    {
        for project in projects
        {
            let index = project.name.startIndex
            let dictIndex = String(project.name.capitalizedString[index])
            if dictionary[dictIndex] == nil
            {
                dictionary[dictIndex] = [Project]()
            }
            dictionary[dictIndex]?.append(project)
        }
    }
    
    
    /*
        iOS Listener function. Setting up popover view for adding new projects.
        
        @methodtype Hook
        @pre Identifier is set
        @post Popover is shown
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "popover_test"
        {
            let popoverViewController = segue.destinationViewController as! UINavigationController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            
            let newProjectViewController = popoverViewController.visibleViewController as! NewProjectViewController
            newProjectViewController.delegate = self
        }
    }
    
    
    /*
        Callback function from adding new project. Reloading all projects.
        
        @methodtype Hook
        @pre -
        @post Reloaded projects
    */
    func didAddNewProject()
    {
        reloadProjects()
    }
    
    
    /*
        
        
        @methodtype
        @pre
        @post
    */
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    
    /*
        iOS function for handling number of sections in table views.
        
        @methodtype Getter
        @pre -
        @post Get number of sections
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return alphabet.count
    }
    
    
    /*
        iOS function for handling section header titles in table views.
        
        @methodtype Getter
        @pre -
        @post Get section header title
    */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if dictionary[alphabet[section]] != nil
        {
            return alphabet[section]
        }
        return nil
    }
    
    
    /*
        iOS function for handling index titles in table views.
        
        @methodtype Getter
        @pre -
        @post Get list of titles
    */
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]!
    {
        return alphabet
    }
    
    
    /*
        Function returns current count of necessary cells.
        
        @methodtype Command
        @pre -
        @post Amount of cells
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let projects = dictionary[alphabet[section]]
        {
            return projects.count
        }
        return 0
    }
    
    
    /*
        Function is called when populating table cells. Maps projects to table cells.
        
        @methodtype Command
        @pre -
        @post Populated cell, ready for use
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: ProjectTableViewCell = projectsTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProjectTableViewCell
        
        if let project = dictionary[alphabet[indexPath.section]]?[indexPath.row]
        {
            cell.projectID.text = "\(project.id)"
            cell.projectName.text = project.name
        }
        
        return cell
    }
    
    
    /*
        Function is called when selecting table row.
    
        @methodtype Command
        @pre -
        @post Prevents from selecting during recording
    */
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        tabBarController?.selectedIndex = 0
        var navigationViewController = tabBarController?.viewControllers?.first as! UINavigationController
        var recordingViewController = navigationViewController.visibleViewController as! RecordingViewController
        recordingViewController.setProject(dictionary[alphabet[indexPath.section]]![indexPath.row])
        
        return indexPath
    }
    
    
    func edit()
    {
        projectsTableView.setEditing(true, animated: true)
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("done")), animated: true)
    }
    
    
    func done()
    {
        projectsTableView.setEditing(false, animated: true)
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("edit")), animated: true)
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        projectDAO.archiveProject(dictionary[alphabet[indexPath.section]]![indexPath.row])
        
        dictionary[alphabet[indexPath.section]]!.removeAtIndex(indexPath.row)
        projectsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
    }
}

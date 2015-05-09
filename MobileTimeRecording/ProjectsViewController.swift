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
    
    var alphabet = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var dictionary: Dictionary<String, [Project]>!
    var projects: [Project]!

    
    override func viewWillAppear(animated: Bool)
    {
        reloadProjects()
    }
    
    
    func reloadProjects()
    {
        dictionary = Dictionary<String, [Project]>()
        projects = projectDAO.getProjects()
        
        archiveProjectsIntoDictionary()
        projectsTableView.reloadData()
    }
    
    
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
    
    
    func didAddNewProject()
    {
        reloadProjects()
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return alphabet.count
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if dictionary[alphabet[section]] != nil
        {
            return alphabet[section]
        }
        return nil
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
}

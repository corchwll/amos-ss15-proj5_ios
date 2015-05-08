//
//  ProjectsViewController.swift
//  MobileTimeRecording
//
//  Created by cdan on 08/05/15.
//  Copyright (c) 2015 develop-group. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var projectsTableView: UITableView!
    
    var projects: [Project] = []

    
    override func viewWillAppear(animated: Bool)
    {
        projects = projectDAO.getProjects()
        projectsTableView.reloadData()
    }
    
    
    /*
        Function returns current count of necessary cells.
        
        @methodtype Command
        @pre -
        @post Amount of cells
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return projects.count
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
        
        var project = projects[indexPath.item]
        cell.projectID.text = "\(project.id)"
        cell.projectName.text = project.name
        
        return cell
    }
    
    
    /*
        Function is called when selecting table row. Prevents user from selecting another row while recording.
        
        @methodtype Command
        @pre -
        @post Prevents from selecting during recording
    */
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        return indexPath
    }
}

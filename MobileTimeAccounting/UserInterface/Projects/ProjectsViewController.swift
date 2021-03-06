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
import MapKit


class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewProjectDelegate, EditProjectDelegate, UISearchResultsUpdating, UITabBarControllerDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var searchBarContainer: UIView!
    
    var searchController = UISearchController(searchResultsController: nil)
    let locationManager = CLLocationManager()
    
    let headersAlphabeticalOrder = [ " ", "#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let headersDistanceOrder = [ " ", "Projects"]
    
    var sectionHeaders = [String]()
    var projectsDictionary = Dictionary<String, [Project]>()
    var projects = [Project]()

    
    /*
        iOS life-cycle function. Initializes 'edit'-button on the left side of the bar.
        
        @methodtype Hook
        @pre Selector function must be implemented
        @post Button for editing projects has been initialized
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpNavigationItemButton()
        setUpSearchController()
        setUpTabBarController()
        setUpLocationManager()
    }
    
    
    /*
        Sets left navigation item button for editing projects.
        
        @methodtype Command
        @pre -
        @post Left navigation item button is set
    */
    func setUpNavigationItemButton()
    {
        if let leftBarButtonItem = navigationItem.leftBarButtonItem
        {
            leftBarButtonItem.target = self
            leftBarButtonItem.action = Selector("edit")
        }
    }
    
    
    /*
        Sets up search controller.
        
        @methodtype Command
        @pre -
        @post Search controller is set up
    */
    func setUpSearchController()
    {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Default
        searchController.searchBar.sizeToFit()
        searchBarContainer.addSubview(searchController.searchBar)
    }
    
    
    /*
        Sets up tab bar controller by setting delegate.
        
        @methodtype Command
        @pre Tab bar controller available
        @post Delegate is set
    */
    func setUpTabBarController()
    {
        tabBarController!.delegate = self
    }
    
    
    /*
        Sets up location manager for updating current location.
        
        @methodtype Command
        @pre Location manager protocol must be implemented
        @post Location manager is set up
    */
    func setUpLocationManager()
    {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
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

        if settings.getPreference(Settings.EnableProjectsSortingByDistance)
        {
            sectionHeaders = headersDistanceOrder
            locationManager.startUpdatingLocation()
            projectsTableView.reloadData()
        }
        else
        {
            sectionHeaders = headersAlphabeticalOrder
            reloadProjects()
        }
    }
    
    
    /*
        Function is reloading all projects into ui.
        
        @methodtype Command
        @pre -
        @post Reloaded projects
    */
    func reloadProjects()
    {
        projects = projectDAO.getProjects()
        archiveProjectsIntoDictionary(projects)
        projectsTableView.reloadData()
    }
    
    
    /*
        Function is archiving all given projects into a dictionary for alphabetical grouping.
        
        @methodtype Command
        @pre Initialized dictionary
        @post Archived projects
    */
    func archiveProjectsIntoDictionary(projects: [Project])
    {
        projectsDictionary.removeAll(keepCapacity: false)
        for project in projects
        {
            if projectManager.isDefaultProject(project)
            {
                if projectsDictionary[headersAlphabeticalOrder[0]] == nil
                {
                    projectsDictionary[headersAlphabeticalOrder[0]] = [Project]()
                }
                projectsDictionary[headersAlphabeticalOrder[0]]!.append(project)
            }
            else
            {
                let index = project.name.startIndex
                let dictIndex = String(project.name.capitalizedString[index])
                if projectsDictionary[dictIndex] == nil
                {
                    projectsDictionary[dictIndex] = [Project]()
                }
                projectsDictionary[dictIndex]?.append(project)
            }
        }
    }
    
    
    /*
        Function is archiving all given projects into a dictionary for sorting by distance.
        
        @methodtype Command
        @pre Initialized dictionary
        @post Archived projects
    */
    func archiveProjectsIntoSortedByDistanceDictionary(projects: [Project])
    {
        projectsDictionary.removeAll(keepCapacity: false)
        for project in projects
        {
            if projectManager.isDefaultProject(project)
            {
                if projectsDictionary[headersDistanceOrder[0]] == nil
                {
                    projectsDictionary[headersDistanceOrder[0]] = [Project]()
                }
                projectsDictionary[headersDistanceOrder[0]]?.append(project)
            }
            else
            {
                if projectsDictionary[headersDistanceOrder[1]] == nil
                {
                    projectsDictionary[headersDistanceOrder[1]] = [Project]()
                }
                projectsDictionary[headersDistanceOrder[1]]?.append(project)
            }
        }
    }
    
    
    /*
        iOS life-cycle function, called when view will disappear. Sets editing false and stops location manager.
        
        @methodtype Hook
        @pre -
        @post Stops location manager and leaves editing mode
    */
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        projectsTableView.setEditing(false, animated: true)
        searchController.active = false
        locationManager.stopUpdatingLocation()
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("edit")), animated: true)
    }
    
    
    /*
        Tab bar delegate function, called when transitioning to a new tab.
        Sets search controller inactive because of ui issues if tab was changed and search is still active.
        
        @methodtype Command
        @pre -
        @post SearchController is inactive
    */
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        searchController.active = false
        return nil
    }

    
    /*
        Called when orientation is changed. Sets search controller inactive and hides/resizes search bar button
        because some ugly effects happen while searching and changing screen orientation.
        
        @methodtype Hook
        @pre Orientation change
        @post Resize search bar and set controller inactive
    */
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        searchController.active = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.frame = CGRectMake(0, 0, size.width, searchController.searchBar.frame.height)
    }
    
    
    /*
        Callback function, called when location manager updates current location.
        
        @methodtype Command
        @pre Projects table view not editing
        @post Refreshes project list, sorted by distance
    */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        if !projectsTableView.editing && !searchController.active
        {
            println("active")
            projects = projectManager.getProjectsSortedByDistance(locations.last as! CLLocation)
            archiveProjectsIntoSortedByDistanceDictionary(projects)
            projectsTableView.reloadData()
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
        if segue.identifier == "new_project_segue"
        {
            let navigationViewController = segue.destinationViewController as! UINavigationController
            navigationViewController.popoverPresentationController!.backgroundColor = UINavigationBar.appearance().barTintColor
            
            let newProjectTableViewController = navigationViewController.visibleViewController as! NewProjectTableViewController
            newProjectTableViewController.delegate = self
        }
        else if segue.identifier == "edit_project_segue"
        {
            let navigationViewController = segue.destinationViewController as! UINavigationController
            let editProjectTableViewController = navigationViewController.visibleViewController as! EditProjectTableViewController

            if let indexPath = sender as? NSIndexPath
            {
                editProjectTableViewController.project = projectsDictionary[sectionHeaders[indexPath.section]]![indexPath.row]
                editProjectTableViewController.delegate = self
            }
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
        Callback function when did edit project. Is reloading all projects.
        
        @methodtype Hook
        @pre -
        @post Reloaded projects
    */
    func didEditProject()
    {
        reloadProjects()
    }
    
    
    /*
        iOS function for handling number of sections in table views.
        
        @methodtype Getter
        @pre -
        @post Get number of sections
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return sectionHeaders.count
    }
    
    
    /*
        iOS function for handling section header titles in table views.
        
        @methodtype Getter
        @pre -
        @post Get section header title
    */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if projectsDictionary[sectionHeaders[section]] != nil
        {
            return sectionHeaders[section]
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
        if settings.getPreference(Settings.EnableProjectsSortingByDistance)
        {
            return nil
        }
        else
        {
            return headersAlphabeticalOrder
        }
    }
    
    
    /*
        Function returns current count of necessary cells.
        
        @methodtype Command
        @pre -
        @post Amount of cells
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let projects = projectsDictionary[sectionHeaders[section]]
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
        let cell = projectsTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProjectTableViewCell

        if let project = projectsDictionary[sectionHeaders[indexPath.section]]?[indexPath.row]
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
        let project = projectsDictionary[sectionHeaders[indexPath.section]]![indexPath.row]
        if projectsTableView.editing
        {
            if projectManager.isDefaultProject(project)
            {
                return nil
            }
            performSegueWithIdentifier("edit_project_segue", sender: indexPath)
        }
        else
        {
            projectManager.setRecentProject(project)
            tabBarController?.selectedIndex = 0
        }
        return indexPath
    }
    
    
    /*
        Function is called when asking for delete confirmation button title. Changed title form "Delete" to "Archive".
        
        @methodtype Command
        @pre -
        @post Returns button title
    */
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String!
    {
        return "Archive"
    }
    
    
    /*
        Function for 'edit'-button selector. Enables editing of projects and morphs 'edit' into 'done'.
        
        @methodtype Command
        @pre -
        @post Editing of projects enabled
    */
    func edit()
    {
        projectsTableView.setEditing(true, animated: true)
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("done")), animated: true)
    }
    
    
    /*
        Function for 'done'-button selector. Disables editing of projects and morphs 'done' into 'edit'.
        
        @methodtype Command
        @pre -
        @post Editing of projects disabled
    */
    func done()
    {
        projectsTableView.setEditing(false, animated: true)
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("edit")), animated: true)
    }
    
    
    /*
        Function is called when editing table cell. Archives the selected project and removes corrosponding table cell.
        
        @methodtype Command
        @pre -
        @post Table cell removed, project archived
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        projectManager.archiveProject(projectsDictionary[sectionHeaders[indexPath.section]]![indexPath.row])
        
        projectsDictionary[sectionHeaders[indexPath.section]]!.removeAtIndex(indexPath.row)
        projectsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
    }
    
    
    /*
        Function is called when checking if row can be edited. Disables editing for default projects.
        
        @methodtype Command
        @pre Needs default project ids for exclusion
        @post Editing for default projects has been disabled
    */
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        var project = projectsDictionary[sectionHeaders[indexPath.section]]![indexPath.row]
        if projectManager.isDefaultProject(project)
        {
            return false
        }
        return true
    }
    
    
    /*
        Updates search results after user input is changed
        
        @methodtype Command
        @pre User input is changed
        @post Updates search results
    */
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        let filteredProjects = filterProjectsForSearchText(searchController.searchBar.text)
        
        if settings.getPreference(Settings.EnableProjectsSortingByDistance)
        {
            archiveProjectsIntoSortedByDistanceDictionary(filteredProjects)
        }
        else
        {
            archiveProjectsIntoDictionary(filteredProjects)
        }
        projectsTableView.reloadData()
    }
    
    
    /*
        Filters projects by a given case insensitive search string.
        
        @methodtype Command
        @pre All input strings are valid
        @post Sets filtered projects
    */
    func filterProjectsForSearchText(searchText: String) -> [Project]
    {
        return projects.filter({(project: Project)->Bool in
            let nameMatch = project.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            let idMatch = project.id.rangeOfString(searchText)
            return nameMatch != nil || idMatch != nil || searchText == ""
        })
    }
}
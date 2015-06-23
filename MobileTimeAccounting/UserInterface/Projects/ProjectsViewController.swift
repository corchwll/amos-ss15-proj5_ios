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


class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewProjectDelegate, UISearchResultsUpdating, UITabBarControllerDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var searchBarContainer: UIView!
    
    let alphabet = [ "#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let headers = [ "#", "Projects"]
    
    var sectionHeaders = [String]()
    var dictionary = Dictionary<String, [Project]>()
    var projects = [Project]()
    
    var searchController = UISearchController(searchResultsController: nil)
    var filteredDictionary = Dictionary<String, [Project]>()
    var filteredProjects = [Project]()
    
    let locationManager = CLLocationManager()

    
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
        Sets up tab bar controller by setting delegate.
        
        @methodtype Command
        @pre Tab bar controller available
        @post Delegate is set
    */
    func setUpTabBarController()
    {
        if tabBarController != nil
        {
            tabBarController!.delegate = self
        }
    }
    
    
    /*
        Sets search controller inactive because of ui issues if tab was changed and search is still active.
        
        @methodtype Command
        @pre -
        @post SearchController is inactive
    */
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController)
    {
        searchController.active = false
    }
    
    
    override func viewWillDisappear(animated: Bool)
    {
        projectsTableView.setEditing(false, animated: true)
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("edit")), animated: true)
        locationManager.stopUpdatingLocation()
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
    
    
    func setUpLocationManager()
    {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        println("location manager running")
        projects = projectManager.getProjectsSortedByDistance(locations.last as! CLLocation)
        archiveProjectsIntoSortedByDistanceDictionary(projects, dictionary: &dictionary)
        projectsTableView.reloadData()
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
            sectionHeaders = headers
            locationManager.startUpdatingLocation()
            projectsTableView.reloadData()
        }
        else
        {
            sectionHeaders = alphabet
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
        archiveProjectsIntoDictionary(projects, dictionary: &dictionary)
        projectsTableView.reloadData()
    }
    
    
    /*
        Function is archiving all given projects into a dictionary for alphabetical grouping.
        
        @methodtype Command
        @pre Initialized dictionary
        @post Archived projects
    */
    func archiveProjectsIntoDictionary(projects: [Project], inout dictionary: Dictionary<String, [Project]>)
    {
        dictionary.removeAll(keepCapacity: false)
        for project in projects
        {
            if project.id == "00001" || project.id == "00002" || project.id == "00003" || project.id == "00004"
            {
                if dictionary["#"] == nil
                {
                    dictionary["#"] = [Project]()
                }
                dictionary["#"]?.append(project)
            }
            else
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
    }
    
    /*
        Function is archiving all given projects into a dictionary for sorting by distance.
        
        @methodtype Command
        @pre Initialized dictionary
        @post Archived projects
    */
    func archiveProjectsIntoSortedByDistanceDictionary(projects: [Project], inout dictionary: Dictionary<String, [Project]>)
    {
        dictionary.removeAll(keepCapacity: false)
        for project in projects
        {
            if project.id == "00001" || project.id == "00002" || project.id == "00003" || project.id == "00004"
            {
                if dictionary[headers[0]] == nil
                {
                    dictionary[headers[0]] = [Project]()
                }
                dictionary[headers[0]]?.append(project)
            }
            else
            {
                if dictionary[headers[1]] == nil
                {
                    dictionary[headers[1]] = [Project]()
                }
                dictionary[headers[1]]?.append(project)
            }
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
            let newProjectTableViewController = navigationViewController.visibleViewController as! NewProjectTableViewController
            newProjectTableViewController.delegate = self
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
        let selectedDictionary = searchController.active ? filteredDictionary : dictionary
        if selectedDictionary[sectionHeaders[section]] != nil
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
            return alphabet
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
        if searchController.active
        {
            if let projects = filteredDictionary[sectionHeaders[section]]
            {
                return projects.count
            }
        }
        else
        {
            if let projects = dictionary[sectionHeaders[section]]
            {
                return projects.count
            }
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

        let selectedDictionary =  searchController.active ? filteredDictionary : dictionary
        if let project = selectedDictionary[sectionHeaders[indexPath.section]]?[indexPath.row]
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
        if projectsTableView.editing
        {
            performSegueWithIdentifier("edit_project_segue", sender: self)
            return indexPath
        }
        else
        {
            searchController.active = false
            tabBarController?.selectedIndex = 0
            
            var navigationViewController = tabBarController?.viewControllers?.first as! UINavigationController
            var recordingViewController = navigationViewController.visibleViewController as! RecordingViewController
            
            let project = dictionary[sectionHeaders[indexPath.section]]![indexPath.row]
            
            recordingViewController.setProject(project)
            return indexPath
        }
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
        locationManager.stopUpdatingLocation()
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
        locationManager.startUpdatingLocation()
    }
    
    
    /*
        Function is called when editing table cell. Archives the selected project and removes corrosponding table cell.
        
        @methodtype Command
        @pre -
        @post Table cell removed, project archived
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        projectDAO.archiveProject(dictionary[alphabet[indexPath.section]]![indexPath.row])
        
        dictionary[alphabet[indexPath.section]]!.removeAtIndex(indexPath.row)
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
        if projectsTableView.editing
        {
            var project = dictionary[sectionHeaders[indexPath.section]]![indexPath.row]
            if project.id == "00001" || project.id == "00002" || project.id == "00003" || project.id == "00004"
            {
                return false
            }
            else
            {
                return true
            }
        }
        return false
    }
    
    
    /*
        Updates search results after user input is changed
        
        @methodtype Command
        @pre User input is changed
        @post Updates search results
    */
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredProjects.removeAll(keepCapacity: false)
        filterProjectsForSearchText(searchController.searchBar.text)
        
        if settings.getPreference(Settings.EnableProjectsSortingByDistance)
        {
            archiveProjectsIntoSortedByDistanceDictionary(filteredProjects, dictionary: &filteredDictionary)
        }
        else
        {
            archiveProjectsIntoDictionary(filteredProjects, dictionary: &filteredDictionary)
        }
        
        projectsTableView.reloadData()
    }
    
    
    /*
        Filters projects by a given case insensitive search string.
        
        @methodtype Command
        @pre All input strings are valid
        @post Sets filtered projects
    */
    func filterProjectsForSearchText(searchText: String)
    {
        filteredProjects = projects.filter({(project: Project)->Bool in
            let nameMatch = project.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            let idMatch = project.id.rangeOfString(searchText)
            return nameMatch != nil || idMatch != nil || searchText == ""
        })
    }
}

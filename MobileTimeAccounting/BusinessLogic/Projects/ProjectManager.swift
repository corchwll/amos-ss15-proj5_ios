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

import Foundation
import MapKit


let projectManager = ProjectManager()


class ProjectManager
{
    let RecentProjectIdKey = "RecentProjectIdKey"
    let userDefaults = NSUserDefaults()
    
    let defaultProjects = [
        Project(id: "00001", name: "Vacation"),
        Project(id: "00002", name: "Illness"),
        Project(id: "00003", name: "Office"),
        Project(id: "00004", name: "Training")
    ]
    
    enum DefaultProject
    {
        case Vacation
        case Illnes
        case Office
        case Training
    }
    
    
    /*
        Returns project with given project id form database.
        
        @methodtype Query
        @pre Project id is valid
        @post Returns project or nil if id does not exist
    */
    func getProject(projectId: String)->Project?
    {
        return projectDAO.getProject(projectId)
    }
    
    
    /*
        Returns all projects sorted by distance to current Location parameter from nearest to furthest.
        
        @methodtype Query
        @pre -
        @post Returns projects sorted by distance
    */
    func getProjectsSortedByDistance(currentLocation: CLLocation)->[Project]
    {
        return sortProjectsByDistance(projectDAO.getProjects(), currentLocation: currentLocation)
    }
    
    
    /*
        Archives project by setting boolean value 'is archived' to true.
        
        @methodtype Command
        @pre Project must be existing
        @post Archives project by setting boolean
    */
    func archiveProject(project: Project)
    {
        if project.id == getRecentProjectId()
        {
            removeRecentProject()
        }
        projectDAO.archiveProject(project)
    }
    
    
    /*
        Sorts all projects in a given projects array by distance from nearest to furthest.
        
        @methodtype Helper
        @pre -
        @post Returns projects sorted by distance
    */
    func sortProjectsByDistance(projects: [Project], currentLocation: CLLocation)->[Project]
    {
        return sorted(projects, {(project1: Project, project2: Project)->Bool in
            return currentLocation.distanceFromLocation(project1.location) < currentLocation.distanceFromLocation(project2.location)})
    }
    
    
    /*
        Marks project as most recent project by storing id into user defaults.
        
        @methodtype Command
        @pre -
        @post Marks project as most recent project
    */
    func setRecentProject(project: Project)
    {
        userDefaults.setObject(project.id, forKey: RecentProjectIdKey)
    }
    
    
    /*
        Returns most recent project by using id from user defaults and querying project form database.
        
        @methodtype Query
        @pre Project must be existend and there must be a recent project
        @post Returns most recent project or nil
    */
    func getRecentProject()->Project?
    {
        if let projectId = getRecentProjectId()
        {
            return getProject(projectId)
        }
        return nil
    }
    
    
    /*
        Returns id of the most recent project.
        
        @methodtype Query
        @pre -
        @post Returns recent project id or nil
    */
    func getRecentProjectId()->String?
    {
        return userDefaults.stringForKey(RecentProjectIdKey)
    }
    
    
    /*
        Removes most recent project mark from project.
    
        @methodtype Command
        @pre -
        @post Removes recent project mark from project
    */
    func removeRecentProject()
    {
        userDefaults.removeObjectForKey(RecentProjectIdKey)
    }
    
    
    /*
        Validates if project is a default project.
        
        @methodtype Boolean Query
        @pre -
        @post Returns boolean if project is default project
    */
    func isDefaultProject(project: Project)->Bool
    {
        let filterCount = defaultProjects.filter({(defaultProject: Project)->Bool in
            return project.id == defaultProject.id}).count
        return filterCount == 1
    }
    
    
    /*
        Returns requested default project as object.
        
        @methodtype Query
        @pre Valid enumeration parameter value
        @post Returns default project object
    */
    func getDefaultProject(defaultProject: DefaultProject)->Project?
    {
        switch defaultProject
        {
        case .Vacation:
            return defaultProjects[0]

        case .Illnes:
            return defaultProjects[1]
        
        case .Office:
            return defaultProjects[2]
        
        case .Training:
            return defaultProjects[3]
            
        default:
            return nil
        }
    }
}
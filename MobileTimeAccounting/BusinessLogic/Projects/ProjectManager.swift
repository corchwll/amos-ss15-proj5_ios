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


class ProjectManager
{
    func getProjectsSortedByDistance(currentLocation: CLLocation)->[Project]
    {
        return sortProjectsByDistance(projectDAO.getProjects(), currentLocation: currentLocation)
    }
    
    
    func sortProjectsByDistance(projects: [Project], currentLocation: CLLocation)->[Project]
    {
        return sorted(projects, {(project1: Project, project2: Project)->Bool in
            return currentLocation.distanceFromLocation(project1.location) < currentLocation.distanceFromLocation(project2.location)})
    }
}
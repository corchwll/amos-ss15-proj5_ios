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


class ProfileTableViewController: UITableViewController
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var employeeIdLabel: UILabel!
    @IBOutlet weak var weeklyWorkingTimeLabel: UILabel!
    @IBOutlet weak var totalVacationTimeLabel: UILabel!
    
    
    /*
        iOS life-cycle function. Loads user profile.
        
        @methodtype Hook
        @pre Initial user profile is set
        @post User profile loaded
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadProfile()
    }
    
    
    /*
        iOS life-cycle function. Loads user profile.
        
        @methodtype Hook
        @pre Initial user profile is set
        @post User profile loaded
    */
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        loadProfile()
    }
    
    
    /*
        Functions is loading current user profile into ui.
        
        @methodtype Command
        @pre Valid user profile
        @post User profile was loaded into ui
    */
    func loadProfile()
    {
        if let profile = profileDAO.getProfile()
        {
            nameLabel.text = profile.firstname + " " + profile.lastname
            employeeIdLabel.text = profile.employeeId
            weeklyWorkingTimeLabel.text = profile.weeklyWorkingTime
            totalVacationTimeLabel.text = profile.totalVacationTime
        }
    }
}

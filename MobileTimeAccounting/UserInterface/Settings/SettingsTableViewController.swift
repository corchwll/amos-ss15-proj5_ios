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


class SettingsTableViewController: UITableViewController
{
    @IBOutlet weak var enableProjectsSortingByDistanceSwitch: UISwitch!
    
    
    /*
        iOS life-cycle function, called when view did load. Sets up preferences.
        
        @methodtype Hook
        @pre -
        @post Preferences are set up
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpPreferences()
    }
    
    
    /*
        Sets up prefrence switch by querying prefrence boolean and setting state.
        
        @methodtype Command
        @pre Preference is available
        @post Switch is set
    */
    func setUpPreferences()
    {
        enableProjectsSortingByDistanceSwitch.setOn(settings.getPreference(Settings.EnableProjectsSortingByDistance), animated: false)
    }
    
    
    /*
        Called when switch value did change Updates prefrence by setting boolean for preference key.
        
        @methodtype Command
        @pre Switch value did change
        @post Preference is updated
    */
    @IBAction func valueDidChange(sender: AnyObject)
    {
        settings.setPreference(Settings.EnableProjectsSortingByDistance, value: enableProjectsSortingByDistanceSwitch.on)
    }
}

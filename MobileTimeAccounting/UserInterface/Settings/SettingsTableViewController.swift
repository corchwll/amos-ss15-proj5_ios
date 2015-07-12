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


class SettingsTableViewController: UITableViewController, UISplitViewControllerDelegate
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
        setUpSplitViewControllerDelegate()
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
        Sets up delegate for split view controller.
        
        @methodtype Command
        @pre Must implement split view controller delegate
        @post Delegate is set
    */
    func setUpSplitViewControllerDelegate()
    {
        self.splitViewController!.delegate = self
    }
    
    
    /*
        Split view controller delegate function for determining if master view controller is hidden.
        
        @methodtype Command
        @pre -
        @post Returns boolean if view controller should hide
    */
    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool
    {
        return false
    }
    
    
    /*
        Split view controller delegate function for determining if secondary view controller shoud collapse.
        
        @methodtype Command
        @pre -
        @post Returns boolean if secondary view controller should collapse
    */
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool
    {
        return true
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

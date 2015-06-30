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
import MessageUI


class DashboardTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var overtimeLabel: UILabel!
    @IBOutlet weak var vacationDaysLabel: UILabel!
    @IBOutlet weak var vacationExpiringWarningLabel: UILabel!

    
    /*
        iOS life-cycle function, called when view did appear. Sets up labels.
        
        @methodtype Hook
        @pre -
        @post Labels are set up
    */
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        setUpOvertimeLabel()
        setUpVacationDaysLabel()
    }
    
    
    /*
        Sets up overtime label.
        
        @methodtype Command
        @pre OvertimeHelper is initialized
        @post Overtime label is set up
    */
    func setUpOvertimeLabel()
    {
        overtimeLabel.text = String(overtimeHelper.getCurrentOvertime())
    }
    
    
    /*
        Sets up vacation days label, displaying vacation days left and total vacation days.
    
        @methodtype Command
        @pre VacationTimeHelper is initialized
        @post Vacation days label is set up
    */
    func setUpVacationDaysLabel()
    {
        let currentDate = NSDate()
        let vacationDaysLeft = vacationTimeHelper.getCurrentVacationDaysLeft(currentDate).description
        let totalVacationDays = profileDAO.getProfile()!.totalVacationTime
        
        if vacationTimeHelper.isExpiring(currentDate)
        {
            vacationExpiringWarningLabel.hidden = false
            vacationDaysLabel.textColor = UIColor.redColor()
        }
        else
        {
            vacationExpiringWarningLabel.hidden = true
            vacationDaysLabel.textColor = UIColor.blackColor()
        }
        vacationDaysLabel.text = "\(vacationDaysLeft) / \(totalVacationDays)"
    }
    
    
    /*
        iOS life-cycle function, called when performing a segue. Sets up popover view for mailing csv file.
        
        @methodtype Hook
        @pre Segue has valid identifier
        @post Popover is shown properly
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "csv_mail_popover"
        {
            let popoverViewController = segue.destinationViewController as! UINavigationController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            
            popoverViewController.navigationBar.barStyle = UIBarStyle.Default
            popoverViewController.navigationBar.translucent = true
            popoverViewController.navigationBar.barTintColor = UIToolbar.appearance().barTintColor
            popoverViewController.popoverPresentationController?.backgroundColor = UIToolbar.appearance().barTintColor
        }
    }
    
    
    /*
        Function is called when asking the UIModalPresentationStyle. Returns 'none' in order to display popup window properly.
        
        @methodtype Command
        @pre -
        @post -
    */
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
}

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


class DashboardTableViewController: UITableViewController
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
        let currentDate = NSDate()
        overtimeLabel.text = overtimeHelper.getCurrentOvertime(currentDate).description
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
}

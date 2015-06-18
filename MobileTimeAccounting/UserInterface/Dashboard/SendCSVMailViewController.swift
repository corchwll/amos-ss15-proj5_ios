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


class SendCSVMailViewController: UIViewController, MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var monthPicker: UIMonthPickerView!
    
    
    /*
        iOS life-cycle function, called when view did load. Sets month picker selection to current date.
        
        @methodtype Hook
        @pre -
        @post Month picker selection is set to current date
    */
    override func viewDidLoad()
    {
        let currentDate = NSDate()
        let currentDateComponents = NSCalendar.currentCalendar().components(.CalendarUnitMonth | .CalendarUnitYear, fromDate: currentDate)
        monthPicker.setSelection(currentDateComponents.month, year: currentDateComponents.year)
    }
    
    
    /*
        Function is called when pressing 'done'-button. Delegates mailing functionality to iOS MessageUI API.
        
        @methodtype Command
        @pre -
        @post Mail composer is initialized and shown
    */
    @IBAction func sendEmail(sender: AnyObject)
    {
        let emailTitle = "Test Email"
        let messageBody = "This is a test email body"
        let toRecipents = ["blabla@mail.com"]
        
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setSubject(emailTitle)
        mailComposeViewController.setMessageBody(messageBody, isHTML: false)
        mailComposeViewController.setToRecipients(toRecipents)
        
        let month = monthPicker.getSelection()
        let monthComponents = NSCalendar.currentCalendar().components(.CalendarUnitMonth | .CalendarUnitYear, fromDate: month)
        mailComposeViewController.addAttachmentData(SessionsCSVExporter().exportCSV(monthComponents.month, year: monthComponents.year), mimeType: "text/csv", fileName: "accounting.csv")
        
        mailComposeViewController.navigationBar.barStyle = UIBarStyle.Black
        presentViewController(mailComposeViewController, animated: true, completion: {UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)})
    }
    
    
    /*
        Function is called when pressing 'cancel'-button. Dismisses current view.
        
        @methodtype Command
        @pre -
        @post View controller dismissed
    */
    @IBAction func cancel(sender: AnyObject)
    {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    /*
        Function is called when mail composer did finish. Dismisses all view controllers and prints out current mailing status.
        
        @methodtype Command
        @pre -
        @post Mailing status is printed out, view controllers are dismissed
    */
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError)
    {
        switch result.value
        {
            case MFMailComposeResultCancelled.value:
                println("Mail cancelled")
            case MFMailComposeResultSaved.value:
                println("Mail saved")
            case MFMailComposeResultSent.value:
                println("Mail sent")
            case MFMailComposeResultFailed.value:
                println("Mail sent failure: \(error.localizedDescription)")
            default:
                break
        }
        
        dismissViewControllerAnimated(false, completion: nil)
        dismissViewControllerAnimated(false, completion: nil)
    }
}

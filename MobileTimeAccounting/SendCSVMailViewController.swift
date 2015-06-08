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
    
    
    override func viewDidLoad()
    {
        monthPicker.setSelection(6, year: 2015)
    }
    
    
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
    
    
    @IBAction func cancel(sender: AnyObject)
    {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    
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

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


protocol NewProjectDelegate
{
    func didAddNewProject()
}


class NewProjectTableViewController: UITableViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var projectIdTextField: UITextField!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var projectFinalDateTextField: UITextField!
    @IBOutlet weak var projectLatitudeTextField: UITextField!
    @IBOutlet weak var projectLongitudeTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var locationProcessIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var validProjectId = false
    
    var delegate: NewProjectDelegate!
    let datePicker = UIDatePicker()
    let dateFormatter = NSDateFormatter()
    let locationManager = CLLocationManager()
    
    
    /*
        iOS life-cycle function, called when view did load. Sets up date formatter and input view for date picker.
        
        @methodtype Hook
        @pre -
        @post -
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpDateFormatter()
        setUpDatePickerInputView()
        setUpLocationManager()
        refreshDoneButtonState()
    }
    
    
    /*
        Function is called to set up date formatter.
        
        @methodtype Command
        @pre -
        @post Date formatter has been set up
    */
    func setUpDateFormatter()
    {
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    
    /*
        Function is called to set up date picker input view.
        
        @methodtype Command
        @pre -
        @post Input view has been set up
    */
    func setUpDatePickerInputView()
    {
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: Selector("datePickerDidChange"), forControlEvents: UIControlEvents.ValueChanged)
        projectFinalDateTextField.inputView = datePicker
    }
    
    
    /*
        
        
        @methodtype
        @pre
        @post
    */
    func setUpLocationManager()
    {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    /*
        Function is called when date picker has changed. Sets text field to selected date.
        
        @methodtype Hook
        @pre -
        @post Final date text field has been set to selected date
    */
    func datePickerDidChange()
    {
        projectFinalDateTextField.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    
    /*
        iOS listener function. Called when editing project id, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func projectIdTimeChanged(sender: AnyObject)
    {
        if Project.isValidId(projectIdTextField.text)
        {
            projectIdTextField.textColor = UIColor.blackColor()
            validProjectId = true
        }
        else
        {
            projectIdTextField.textColor = UIColor.redColor()
            validProjectId = false
        }
        refreshDoneButtonState()
    }
    
    
    /*
        iOS listener function. Called when editing project name, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func projectNameChanged(sender: AnyObject)
    {
        refreshDoneButtonState()
    }
    
    
    /*
        Function for enabling 'done'-button. Button will be enabled when all mandatory text fiels are filled.
        
        @methodtype Command
        @pre Text field are not empty
        @post Button will be enabled
    */
    func refreshDoneButtonState()
    {
        var isValid = true
        
        isValid = isValid && validProjectId
        isValid = isValid && !projectNameTextField.text.isEmpty
    
        doneButton.enabled = isValid
    }
    
    
    /*
        Determines current location and fills in coordinates into ui. Start process indicator animation and hides button.
        
        @methodtype Command
        @pre Location manager has been initialized
        @post Finding location process is triggered
    */
    @IBAction func getCurrentLocation(sender: AnyObject)
    {
        locationManager.startUpdatingLocation()
        findLocationButton.hidden = true
        locationProcessIndicatorView.startAnimating()
    }
    
    
    /*
        Function is called when location is found. Updated coordinates text fields and stops process indicator animation.
        Also stops the process of finding new locations.
        
        @methodtype Command
        @pre Location was found
        @post Coordinates has been printed
    */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        let location = locations.last as! CLLocation
        projectLatitudeTextField.text = "\(location.coordinate.latitude)"
        projectLongitudeTextField.text = "\(location.coordinate.longitude)"
        
        locationManager.stopUpdatingLocation()
        locationProcessIndicatorView.stopAnimating()
        findLocationButton.hidden = false
    }
    
    
    /*
        Called when new project should be added. Stores new project into sqlite database by using
        project data access object.
    
        @methodtype Command
        @pre Valid user input
        @post New project added and current view dismissed
    */
    @IBAction func addProject(sender: AnyObject)
    {
        let newProject = Project(id: projectIdTextField.text, name: projectNameTextField.text, finalDate: dateFormatter.dateFromString(projectFinalDateTextField.text), latitude: projectLatitudeTextField.text.toDouble(), longitude: projectLongitudeTextField.text.toDouble())

        projectDAO.addProject(newProject)
        delegate.didAddNewProject()
        dismissViewControllerAnimated(true, completion: {})
    }
    
    
    /*
        iOS listener function. Called when pressing 'cancel'-button, dismissing current view.
        
        @methodtype Command
        @pre -
        @post -
    */
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

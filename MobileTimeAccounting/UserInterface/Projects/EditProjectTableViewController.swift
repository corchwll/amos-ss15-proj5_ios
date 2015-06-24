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


protocol EditProjectDelegate
{
    func didEditProject()
}


class EditProjectTableViewController: UITableViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var projectIDLabel: UILabel!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var projectFinalDateTextField: UITextField!
    @IBOutlet weak var projectLatitudeTextField: UITextField!
    @IBOutlet weak var projectLongitudeTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var locationProcessIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var delegate: EditProjectDelegate!
    var project: Project!
    let datePicker = UIDatePicker()
    let dateFormatter = NSDateFormatter()
    let locationManager = CLLocationManager()
    
    
    /*
        iOS life-cycle function, called when view did load. Sets up date formatter and input view for date picker.
        
        @methodtype Hook
        @pre -
        @post View is set up
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpDateFormatter()
        setUpDatePickerInputView()
        setUpLocationManager()
        setUpProject()
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
        Sets up location manager.
        
        @methodtype Command
        @pre Location manager must be initialized
        @post Location manager is set up
    */
    func setUpLocationManager()
    {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    /*
        Sets up project that is about to be edited.
        
        @methodtype Command
        @pre Project must be set
        @post Project is set, ui is updated
    */
    func setUpProject()
    {
        projectIDLabel.text = project.id
        projectNameTextField.text = project.name
        projectFinalDateTextField.text = dateFormatter.stringFromDate(project.finalDate)
        projectLatitudeTextField.text = "\(project.location.coordinate.latitude)"
        projectLongitudeTextField.text = "\(project.location.coordinate.longitude)"
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
        iOS listener function. Called when editing project name, refreshes 'done'-button state.
        
        @methodtype Command
        @pre -
        @post Refreshes done button
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
        var isEmpty = false
        
        isEmpty = isEmpty || projectNameTextField.text.isEmpty
        
        doneButton.enabled = !isEmpty
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
        Called when project editing is done. Updates project in database.
    
        @methodtype Command
        @pre Valid user input
        @post Project is updated
    */
    @IBAction func updateProject(sender: AnyObject)
    {
        let updatedProject = Project(id: projectIDLabel.text!, name: projectNameTextField.text, finalDate: dateFormatter.dateFromString(projectFinalDateTextField.text), latitude: projectLatitudeTextField.text.toDouble(), longitude: projectLongitudeTextField.text.toDouble())
        
        projectDAO.updateProject(updatedProject)
        delegate.didEditProject()
        dismissViewControllerAnimated(true, completion: {})
    }
    
    
    /*
        iOS listener function. Called when pressing 'cancel'-button, dismisses current view.
        
        @methodtype Command
        @pre -
        @post Dismisses current view
    */
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}

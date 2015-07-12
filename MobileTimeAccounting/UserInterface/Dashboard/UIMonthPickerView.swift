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


class UIMonthPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate
{
    let picker = UIPickerView()
    let calendar = NSCalendar.currentCalendar()
    var monthDescriptions = [String]()
    var months = [Int]()
    var years = [Int]()
    
    
    /*
        Constructor for initializing month picker view.
        
        @methodtype Constructor
        @pre -
        @post -
    */
    override init(frame: CGRect)
    {
        super.init(frame: frame)

        setUpPicker()
    }
    
    
    /*
        Constructor for initializing month picker view.
        
        @methodtype Constructor
        @pre -
        @post -
    */
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)

        setUpPicker()
    }
    
    
    /*
        Sets up internal picker.
        
        @methodtype Command
        @pre -
        @post Picker is set up
    */
    func setUpPicker()
    {
        setUpPickerView()
        setUpMonths()
        setUpYears()
        picker.reloadAllComponents()
    }
    
    
    /*
        Sets up internal picker view, by providing delegate and data source.
        
        @methodtype Command
        @pre -
        @post Picker view is set up
    */
    func setUpPickerView()
    {
        self.addSubview(picker)
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: picker, attribute: .Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: picker, attribute: .Trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: picker, attribute: .Top, multiplier: 1, constant: 0))
        picker.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        picker.delegate = self
        picker.dataSource = self
    }
    
    
    /*
        Sets up months for picker view. To allow continous scrolling a loop of month values from 1 to 12 is set.
        
        @methodtype Command
        @pre -
        @post Months for picker are set up
    */
    func setUpMonths()
    {
        setUpMonthDescriptions()
        
        for index in 0..<1200
        {
            months.append(index%12 + 1)
        }
        picker.selectRow(600, inComponent: 0, animated: false)
    }
    
    
    /*
        Sets up month description, used to format months in picker view.
        
        @methodtype Command
        @pre -
        @post Month descriptions are set up
    */
    func setUpMonthDescriptions()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        for index in 1...12
        {
            monthDescriptions.append(dateFormatter.stringFromDate(NSDate(month: index, year: 0, calendar: calendar)))
        }
    }
    
    
    /*
        Sets up years for picker view. Default range goes from 2000 to 3000.
        
        @methodtype Command
        @pre -
        @post Years for picker are set up
    */
    func setUpYears()
    {
        for index in 2000...3000
        {
            years.append(index)
        }
        picker.selectRow(0, inComponent: 1, animated: false)
    }
    
    
    /*
        Sets current selection in picker view.
        
        @methodtype Setter
        @pre Month and year must be in default range
        @post Picker view selection is set
    */
    func setSelection(month: Int, year: Int)
    {
        picker.selectRow(599 + month, inComponent: 0, animated: false)
        picker.selectRow(year - 2000, inComponent: 1, animated: false)
    }
    
    
    /*
        Returns current selection as date.
        
        @methodtype Getter
        @pre -
        @post Returns current selection
    */
    func getSelection()->NSDate
    {
        return NSDate(month: months[picker.selectedRowInComponent(0)], year: years[picker.selectedRowInComponent(1)], calendar: calendar)
    }
    
    
    /*
        UIPickerViewDataSource protocol function. Returns number of components in picker view. (1 component)
        
        @methodtype Getter
        @pre -
        @post Returns number of components
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 2
    }
    
    
    /*
        UIPickerViewDataSource protocol function. Returns width for components.
        
        @methodtype Getter
        @pre -
        @post Returns width for components
    */
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return 80
    }
    
    
    /*
        UIPickerViewDataSource protocol function. Returns row height for a component.
        
        @methodtype Getter
        @pre -
        @post Returns row height for a component
    */
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 35
    }
    
    
    /*
        UIPickerViewDataSource protocol function. Returns number of rows in component.
        
        @methodtype Getter
        @pre -
        @post Returns number of rows
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch component
        {
        case 0:
            return months.count
        
        case 1:
            return years.count
        
        default:
            return 0
        }
    }
    
    
    /*
        UIPickerViewDelegate protocol function. Returns formatted date title for each row.
        
        @methodtype Getter
        @pre -
        @post Returns title for each row
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        switch component
        {
        case 0:
            return monthDescriptions[months[row]-1]
            
        case 1:
            return years[row].description
            
        default:
            return ""
        }
    }
}

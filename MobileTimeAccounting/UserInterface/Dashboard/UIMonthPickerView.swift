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
    let calendar = NSCalendar.currentCalendar()
    let dateFormatter = NSDateFormatter()
    var months = [NSDate]()
    let picker = UIPickerView()
    
    
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
        @post 0
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
        setUpDateFormatter()
        setUpMonts()
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
        picker.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height-26)
        picker.delegate = self
        picker.dataSource = self
        self.addSubview(picker)
    }

    
    /*
        Sets up date formatter, used to format dates in picker view.
        
        @methodtype Command
        @pre -
        @post Date formatter is set up
    */
    func setUpDateFormatter()
    {
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateFormat = "MMM    yyyy"
    }
    
    
    /*
        Sets up months shown in picker view. Default range from 'Jan 1' to 'Dec 10000'
        
        @methodtype Command
        @pre -
        @post Months for picker are set up
    */
    func setUpMonts()
    {
        var month = NSDateComponents()
        
        for year in 2000...3000
        {
            for index in 1...12
            {
                month.month = index
                month.year = year
                months.append(calendar.dateFromComponents(month)!)
            }
        }

    }
    
    
    /*
        Sets current selection in picker view.
        
        @methodtype Setter
        @pre Month and year must be in default range
        @post Picker view selection is set
    */
    func setSelection(month: Int, year: Int)
    {
        let index = (year - 1) * 12 + month
        picker.selectRow(index - 2000*12, inComponent: 0, animated: false)
    }
    
    
    /*
        Returns current selection as date.
        
        @methodtype Getter
        @pre -
        @post Returns current selection
    */
    func getSelection()->NSDate
    {
        return months[picker.selectedRowInComponent(0)]
    }
    
    
    /*
        UIPickerViewDataSource protocol function. Returns number of components in picker view. (1 component)
        
        @methodtype Getter
        @pre -
        @post Returns number of components
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    /*
        UIPickerViewDataSource protocol function. Returns number of rows in component.
        
        @methodtype Getter
        @pre -
        @post Returns number of rows
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return months.count
    }
    
    
    /*
        UIPickerViewDelegate protocol function. Returns formatted date title for each row.
        
        @methodtype Getter
        @pre -
        @post Returns title for each row
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return dateFormatter.stringFromDate(months[row])
    }
}

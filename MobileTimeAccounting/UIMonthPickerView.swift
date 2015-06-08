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
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setUpPicker()
    }
    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setUpPicker()
    }
    
    
    func setUpPicker()
    {
        setUpPickerView()
        setUpDateFormatter()
        setUpMonts()
        picker.reloadAllComponents()
    }
    
    
    func setUpPickerView()
    {
        picker.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height-26)
        picker.delegate = self
        picker.dataSource = self
        self.addSubview(picker)
    }

    
    func setUpDateFormatter()
    {
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateFormat = "MMM    yyyy"
    }
    
    
    func setUpMonts()
    {
        var month = NSDateComponents()
        
        for year in 1...10000
        {
            for index in 1...12
            {
                month.month = index
                month.year = year
                months.append(calendar.dateFromComponents(month)!)
            }
        }

    }
    
    
    func setSelection(month: Int, year: Int)
    {
        let index = (year - 1) * 12 + month
        picker.selectRow(index, inComponent: 0, animated: false)
    }
    
    
    func getSelection()->NSDate
    {
        return months[picker.selectedRowInComponent(0)]
    }
    
    
    func setUpPickerSelection()
    {
        let currentDate = calendar.components(.CalendarUnitMonth | .CalendarUnitYear, fromDate: NSDate())
        
        picker.selectRow(currentDate.year, inComponent: 1, animated: false)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return months.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return dateFormatter.stringFromDate(months[row])
    }
}

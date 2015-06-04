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

import Foundation


class CSVBuilder
{
    var header = [String]()
    var rows = [[String]]()
    
    
    func setHeaders(header: String...)
    {
        self.header += header
    }
    
    
    func addRow(row: String...)
    {
        rows.append(row)
    }
    
    
    func build()->String
    {
        var csvString = generateHeader()
        csvString += generateRows()
        
        return csvString
    }
    
    
    private func generateHeader()->String
    {
        var csvHeader = ""
        
        for heading in header
        {
            csvHeader += "\(heading),"
        }
        csvHeader.removeAtIndex(csvHeader.endIndex)
        csvHeader.append(Character("/n"))
        
        return csvHeader
    }
    
    
    private func generateRows()->String
    {
        var csvRows = ""
        
        for row in rows
        {
            for item in row
            {
                csvRows += "\(item)),"
            }
            csvRows.removeAtIndex(csvRows.endIndex)
            csvRows.append(Character("/n"))
        }
        
        return csvRows
    }
}
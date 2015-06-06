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
    var rows = [[String]]()
    
    
    func addRow(row: String...)
    {
        rows.append(row)
    }
    
    
    func setRow(rowIndex: Int, row: String...)
    {
        AppendEmptyRowsIfNeeded(rowIndex)
        rows[rowIndex] = row
    }
    
    
    func addRowItem(rowIndex: Int, rowItem: String)
    {
        AppendEmptyRowsIfNeeded(rowIndex)
        rows[rowIndex].append(rowItem)
    }
    
    
    func setRowItem(rowIndex: Int, rowItemIndex: Int, rowItem: String)
    {
        AppendEmptyRowsIfNeeded(rowIndex)
        AppendEmptyRowItemsIfNeeded(rowIndex, toIndex: rowItemIndex)
        
        rows[rowIndex][rowItemIndex] = rowItem
    }
    
    
    private func AppendEmptyRowsIfNeeded(toIndex: Int)
    {
        for var index = rows.count; index <= toIndex; ++index
        {
            rows.append([String]())
        }
    }
    
    
    private func AppendEmptyRowItemsIfNeeded(rowIndex: Int, toIndex: Int)
    {
        for var index = rows[rowIndex].count; index <= toIndex; ++index
        {
            rows[rowIndex].append("")
        }
    }
    
    
    func build()->String
    {
        var csvString = ""
        let columnCount = getColumnCount()

        for row in rows
        {
            csvString += "\(getCSVRow(row, size: columnCount))\n"
        }
        
        return csvString
    }
    
    
    private func getColumnCount()->Int
    {
        var maxCount = 0
        for row in rows
        {
            maxCount = row.count > maxCount ? row.count : maxCount
        }
        return maxCount
    }
    
    
    private func getCSVRow(row: [String], size: Int)->String
    {
        var csvRow = ""
        for column in 0..<size
        {
            csvRow += column < row.count ? "\(row[column])," : ","
        }
        csvRow.removeAtIndex(csvRow.endIndex.predecessor())
        return csvRow
    }
}
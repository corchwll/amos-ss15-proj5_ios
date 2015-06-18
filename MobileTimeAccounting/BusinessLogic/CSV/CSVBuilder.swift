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
    
    
    /*
        Adds a new row at the end of the future csv file.
        
        @methodtype Setter
        @pre Row items must be valid strings for csv file
        @post New row is added
    */
    func addRow(row: String...)
    {
        rows.append(row)
    }
    
    
    /*
        Sets a new row at a given row index.
        
        @methodtype Setter
        @pre Row items must be valid strings for csv file
        @post New row is set at given index
    */
    func setRow(rowIndex: Int, row: String...)
    {
        AppendEmptyRowsIfNeeded(rowIndex)
        rows[rowIndex] = row
    }
    
    
    /*
        Adds a new row item at the end of a given row.
        
        @methodtype Setter
        @pre Row item must be a valid strings for csv file
        @post New row item is added
    */
    func addRowItem(rowIndex: Int, rowItem: String)
    {
        AppendEmptyRowsIfNeeded(rowIndex)
        rows[rowIndex].append(rowItem)
    }
    
    
    /*
        Sets a new row item at a given index in a given row.
        
        @methodtype Setter
        @pre Row items must be valid strings for csv file
        @post New row item is set
    */
    func setRowItem(rowIndex: Int, rowItemIndex: Int, rowItem: String)
    {
        AppendEmptyRowsIfNeeded(rowIndex)
        AppendEmptyRowItemsIfNeeded(rowIndex, toIndex: rowItemIndex)
        
        rows[rowIndex][rowItemIndex] = rowItem
    }
    
    
    /*
        Adds empty rows(empty string arrays) up to a given index if there aren't already rows.
        
        @methodtype Command
        @pre Rows must be nil
        @post Empty rows are added
    */
    private func AppendEmptyRowsIfNeeded(toIndex: Int)
    {
        for var index = rows.count; index <= toIndex; ++index
        {
            rows.append([String]())
        }
    }
    
    
    /*
        Adds empty row items (strings) up to a given index in a row, but only if there aren't already row items set.
        
        @methodtype Command
        @pre Row items must be nil
        @post Empty row items are added
    */
    private func AppendEmptyRowItemsIfNeeded(rowIndex: Int, toIndex: Int)
    {
        for var index = rows[rowIndex].count; index <= toIndex; ++index
        {
            rows[rowIndex].append("")
        }
    }
    
    
    /*
        Builds the csv string by converting rows into a csv format seperated by colons.
        
        @methodtype Helper
        @pre Rows are set
        @post Returns valid csv string
    */
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
    
    
    /*
        Returns total column count, determined by the longest row in all rows.
        
        @methodtype Helper
        @pre Rows are set
        @post Returns total column count
    */
    private func getColumnCount()->Int
    {
        var maxCount = 0
        for row in rows
        {
            maxCount = row.count > maxCount ? row.count : maxCount
        }
        return maxCount
    }
    
    
    /*
        Returns a row converted into a csv string.
        
        @methodtype Convertion
        @pre Size must be greater than or equal current row size
        @post Returns row as csv string
    */
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
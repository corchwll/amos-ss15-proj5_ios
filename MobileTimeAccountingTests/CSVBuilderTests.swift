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

import XCTest


/*
    Naming convention for all tests: 'UnitOfWork_StateUnderTest_ExpectedBehavior'
*/
class CSVBuilderTests: XCTestCase
{
    let header = ["Vorname", "Name", "Datum", "Alter"]
    let row1 = ["Max", "Lieb", "2015", "43"]
    let row2 = ["Heinz", "Schlosser", "2014", "19"]
    let row3 = ["Friedrich", "Mueller", "2011", "23"]
    let row4 = ["Holger", "Unze", "2010", "30"]
    let row5 = ["Walter", "Herzog", "1999", "35"]
    
    let csvString1 = "Vorname,Name,Datum,Alter\nMax,Lieb,2015,43\nHeinz,Schlosser,2014,19\nFriedrich,Mueller,2011,23\nHolger,Unze,2010,30\nWalter,Herzog,1999,35\n"
    let csvString2 = "Vorname,Name,Datum,Alter,,\nMax,Lieb,2015,43,test1,\nHeinz,Schlosser,2014,19,,\nFriedrich,Mueller,2011,23,test2,test3\nHolger,Unze,2010,30,,\nWalter,Herzog,1999,35,,\n"
    
    
    override func setUp()
    {
        super.setUp()
    }
    
    
    override func tearDown()
    {
        super.tearDown()
    }

    
    func testBuild_ValidRowsAreGiven_ValidCSVStringGenerated()
    {
        let csvBuilder = CSVBuilder()
        csvBuilder.addRow(header[0], header[1], header[2], header[3])
        csvBuilder.addRow(row1[0], row1[1], row1[2], row1[3])
        csvBuilder.addRow(row2[0], row2[1], row2[2], row2[3])
        csvBuilder.addRow(row3[0], row3[1], row3[2], row3[3])
        csvBuilder.addRow(row4[0], row4[1], row4[2], row4[3])
        csvBuilder.addRow(row5[0], row5[1], row5[2], row5[3])
        let csvString = csvBuilder.build()

        XCTAssert(csvString == csvString1, "Pass")
    }
    
    
    func testBuild_ValidRowsAreGivenButSomeRowsAreLongerThanOthers_ValidCSVStringGenerated()
    {
        let csvBuilder = CSVBuilder()
        csvBuilder.addRow(header[0], header[1], header[2], header[3])
        csvBuilder.addRow(row1[0], row1[1], row1[2], row1[3], "test1")
        csvBuilder.addRow(row2[0], row2[1], row2[2], row2[3])
        csvBuilder.addRow(row3[0], row3[1], row3[2], row3[3], "test2", "test3")
        csvBuilder.addRow(row4[0], row4[1], row4[2], row4[3])
        csvBuilder.addRow(row5[0], row5[1], row5[2], row5[3])
        let csvString = csvBuilder.build()
        
        XCTAssert(csvString == csvString2, "Pass")
    }
    
    
    func testBuild_ValidRowsAreGivenButRow4IsMissing_CSVStringNotGenerated()
    {
        let csvBuilder = CSVBuilder()
        csvBuilder.addRow(header[0], header[1], header[2], header[3])
        csvBuilder.addRow(row1[0], row1[1], row1[2], row1[3])
        csvBuilder.addRow(row2[0], row2[1], row2[2], row2[3])
        csvBuilder.addRow(row3[0], row3[1], row3[2], row3[3])
        csvBuilder.addRow(row5[0], row5[1], row5[2], row5[3])
        let csvString = csvBuilder.build()
        
        XCTAssert(csvString != csvString1, "Pass")
    }
    
    
    func testBuild_RowsAreNotSet_EmptyStringIsGenerated()
    {
        let csvBuilder = CSVBuilder()
        let csvString = csvBuilder.build()
        
        XCTAssert(csvString.isEmpty, "Pass")
    }
}

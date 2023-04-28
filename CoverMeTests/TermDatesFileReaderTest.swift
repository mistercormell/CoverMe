//
//  TermDatesFileReaderTest.swift
//  CoverMeTests
//
//  Created by Cormell, David - DPC on 28/04/2023.
//

import XCTest
@testable import CoverMe

final class TermDatesFileReaderTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func createDateFrom(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.date(from: string) ?? Date.now
    }

    func testCreateTermStartDateFromLineIsNotNil() {
        //arrange
        let line = "09-01-2023,Lent"
        let expected = TermDate(term: Term.Lent, date: createDateFrom(string: "09/01/2023"))
        //act
        let termDate = TermDatesFileReader.createTermStartDateFrom(line: line)
        //assert
        XCTAssertNotNil(termDate)
    }
    
    func testCreateTermDatesFromFile() {
        let actual = TermDatesFileReader.createTermDatesFromFile(filename: "termdates")
        
        XCTAssertEqual(actual.startDates.count, 5)
    }

}

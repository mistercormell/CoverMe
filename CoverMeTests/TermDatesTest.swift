//
//  TermDatesTest.swift
//  CoverMeTests
//
//  Created by Cormell, David - DPC on 03/05/2023.
//

import XCTest
@testable import CoverMe

final class TermDatesTest: XCTestCase {

    private func createDateFrom(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.date(from: string) ?? Date.now
    }
    
    func testTermDatePrefixTest() {
        //arrange
        //act
        //assert
        XCTAssertEqual(Term.Michaelmas.displayInitial, "M")
        XCTAssertEqual(Term.Lent.displayInitial, "L")
        XCTAssertEqual(Term.Summer.displayInitial, "S")
    }
    
    //TODO - add case where date is outside the range of term dates loaded in to handle error case
    func testGetTermDisplayForRangeOfDates() {
        //arrange
        
        var startDates: [TermDate] = []
        startDates.append(TermDate(term: Term.Lent, date: createDateFrom(string: "09/01/2023")))
        startDates.append(TermDate(term: Term.Summer, date: createDateFrom(string: "17/04/2023")))
        startDates.append(TermDate(term: Term.Michaelmas, date: createDateFrom(string: "04/09/2023")))
        startDates.append(TermDate(term: Term.Lent, date: createDateFrom(string: "08/01/2024")))
        startDates.append(TermDate(term: Term.Summer, date: createDateFrom(string: "15/04/2024")))
        let termDates = TermDates(startDates: startDates)
        
        let testCases = [(date: "10/01/2023", expected: "L23"),
                         (date: "16/04/2023", expected: "L23"),
                         (date: "04/09/2023", expected: "M23"),
                         (date: "10/10/2023", expected: "M23"),
                         (date: "10/01/2024", expected: "L24"),
                         (date: "20/04/2024", expected: "S24"),
                         (date: "01/01/2023", expected: "L23"),
                         (date: "09/01/2023", expected: "L23")]
        
        //act
        //assert
        for testCase in testCases {
            let actual = termDates.getTermDisplay(for: createDateFrom(string: testCase.date))
            XCTAssertEqual(actual, testCase.expected)
        }
    }

}

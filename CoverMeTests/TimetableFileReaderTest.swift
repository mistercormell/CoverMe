//
//  TimetableFileReaderTest.swift
//  CoverMeTests
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import XCTest
@testable import CoverMe

final class TimetableFileReaderTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateTimetableFromFileOutputsContentsOfFile() {
        //arrange
        let reader = TimetableFileReader()
        //act
        reader.createTimetableFromFile(filename: "timetable")
    }

}

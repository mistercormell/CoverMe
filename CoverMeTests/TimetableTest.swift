//
//  TimetableTest.swift
//  CoverMeTests
//
//  Created by Cormell, David - DPC on 08/02/2023.
//

import XCTest
@testable import CoverMe

final class TimetableTest: XCTestCase {

    //TODO - change test so no longer dependent on TimetableFileReader
    func testTimetableGetRoomSKGandWednesday3rdGivesValidRoom()  {
        //arrange
        let timetable = TimetableFileReader.createTimetableFromFile(filename: "timetable")
        let expected = Room.Birley2
        
        //act
        let actual = timetable.getRoomFor(lesson: Lesson.Wednesday3rd, teacher: Teacher(initials: "SKG"))
        
        //assert
        XCTAssertEqual(actual, expected)
    }
    
    //TODO create test
    func testTimetable2022To2023HasCorrectStaffTotals() {
        
    }


}

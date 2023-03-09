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
    
    func testDoesTeachInVariousReturnsAsExpected() {
        //arrange
        let timetable = TimetableFileReader.createTimetableFromFile(filename: "timetable")
        let testCases = [(initials: "SKG", lesson: Lesson.Monday3rd, expected: true),
                         (initials: "DPC", lesson: Lesson.Tuesday3rd, expected: false),
                         (initials: "JWFS", lesson: Lesson.Saturday3rd, expected: false),
                         (initials: "SJT", lesson: Lesson.Wednesday3rd, expected: false),
                         (initials: "MC", lesson: Lesson.Monday3rd, expected: false),
                         (initials: "SKG", lesson: Lesson.Thursday5th, expected: true)]
        
        //act
        //assert
        for testCase in testCases {
            let actual = timetable.doesTeachIn(testCase.lesson, for: Teacher(initials: testCase.initials))
            XCTAssertEqual(actual, testCase.expected)
        }
    }
    
    func testTimetableLessonDisplayNameReturnsWithSpaces() {
        //arrange
        let lesson = Lesson.Monday1st
        //act
        let actual = lesson.displayName
        //assert
        XCTAssertEqual(actual, "Monday 1st")
    }
    
    func testTimetableLessonDayOfWeekReturnsAsExpected() {
        //arrange
        let lesson = Lesson.Monday1st
        //act
        let actual = lesson.dayOfWeek
        //assert
        XCTAssertEqual(actual, "Monday")
    }


}

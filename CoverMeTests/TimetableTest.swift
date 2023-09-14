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
        let timetable = TimetableFileReader.initialiseTimetableAndStaffData().0
        let expected = Room.Birley2
        
        //act
        let actual = timetable.getRoomFor(lesson: Lesson.Wednesday3rd, teacher: Teacher(initials: "MDS", department: .ComputerScience, email: "m.stockdale@etoncollege.org.uk"))
        
        //assert
        XCTAssertEqual(actual, expected)
    }
    
    //TODO create test
    func testTimetable2022To2023HasCorrectStaffTotals() {
        
    }
    
    func testDoesTeachInVariousReturnsAsExpected() {
        //arrange
        let data = TimetableFileReader.initialiseTimetableAndStaffData()
        let timetable = data.0
        let testCases = [(initials: "SKG", lesson: Lesson.Monday3rd, expected: true),
                         (initials: "DPC", lesson: Lesson.Tuesday3rd, expected: false),
                         (initials: "JWFS", lesson: Lesson.Saturday3rd, expected: false),
                         (initials: "SJT", lesson: Lesson.Wednesday3rd, expected: false),
                         (initials: "MC", lesson: Lesson.Monday3rd, expected: false),
                         (initials: "SKG", lesson: Lesson.Thursday5th, expected: true)]
        
        //act
        //assert
        for testCase in testCases {
            let teacher = TimetableFileReader.getTeacher(by: testCase.initials, teachers: data.1)
            let actual = timetable.doesTeachIn(testCase.lesson, for: teacher)
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

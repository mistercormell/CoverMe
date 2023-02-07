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

    func testCreateTimetabledLessonFromLineWithValidLineReturnsTimetabledLesson() {
        //arrange
        let line = "Monday2nd,BComV-1,MC,Keate1"
        let expected = TimetabledLesson(lesson: Lesson.Monday2nd, teacher: Teacher(initials: "MC"), division: Division(code: "BComV-1"), room: Room.Keate1)
        //act
        let actual = TimetableFileReader.createTimetabledLessonFromLine(line: line)
        //assert
        XCTAssertEqual(actual, expected)
        
    }
    
    func testCreateTimetabledLessonFromLineWithInvalidRoomReturnsNil() {
        //arrange
        let line = "Monday1st,BComV-1,MC,Keate3"
        //act
        let actual = TimetableFileReader.createTimetabledLessonFromLine(line: line)
        //assert
        XCTAssertNil(actual)
    }
    
    func testCreateTimetabledLessonFromLineWithInvalidDayReturnsNil() {
        //arrange
        let line = "Monday7th,BComV-1,MC,Keate1"
        //act
        let actual = TimetableFileReader.createTimetabledLessonFromLine(line: line)
        //assert
        XCTAssertNil(actual)
    }
    
    //TODO - replace to use mocked file rather than actual file
    func testCreateTimetableFromFileWithGenuineFileReturnsNonNil() {
        //arrange
        //act
        let actual = TimetableFileReader.createTimetableFromFile(filename: "timetable")
        //assert
        XCTAssertNotNil(actual)
    }
}

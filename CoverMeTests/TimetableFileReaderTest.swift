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
        let teacher = Teacher(initials: "MC", department: Department.ComputerScience, email: "m.collins@etoncollege.org.uk")
        let expected = TimetabledLesson(lesson: Lesson.Monday2nd, teacher: teacher, division: Division(code: "BComV-1"), room: Room.Keate1)
        //act
        let actual = TimetableFileReader.createTimetabledLessonFromLine(line: line, teachers: [teacher])
        //assert
        XCTAssertEqual(actual, expected)
        
    }
    
    func testCreateTimetabledLessonFromLineWithInvalidRoomReturnsNil() {
        //arrange
        let line = "Monday1st,BComV-1,MC,Keate3"
        let teacher = Teacher(initials: "MC", department: Department.ComputerScience, email: "m.collins@etoncollege.org.uk")
        //act
        let actual = TimetableFileReader.createTimetabledLessonFromLine(line: line, teachers: [teacher])
        //assert
        XCTAssertNil(actual)
    }
    
    func testCreateTimetabledLessonFromLineWithInvalidDayReturnsNil() {
        //arrange
        let line = "Monday8th,BComV-1,MC,Keate1"
        let teacher = Teacher(initials: "MC", department: Department.ComputerScience, email: "m.collins@etoncollege.org.uk")
        //act
        let actual = TimetableFileReader.createTimetabledLessonFromLine(line: line, teachers: [teacher])
        //assert
        XCTAssertNil(actual)
    }
    
    //TODO - replace to use mocked file rather than actual file
    func testCreateTimetableFromFileWithGenuineFileReturnsNonNil() {
        //arrange
        //act
        let actual = TimetableFileReader.createTimetableFromFileWithTeachers(filename: "timetable", teachers: [])
        //assert
        XCTAssertNotNil(actual)
    }
}

//
//  CoverManagerTest.swift
//  CoverMeTests
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import XCTest
@testable import CoverMe

final class CoverManagerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCoverOptionsWith1ValidPersonAbleToCoverReturns2CoverArrangementsWithCorrectDetails() {
        //arrange
        let timetabledLessons = Timetable.example
        let coverManager = CoverManager(timetable: Timetable(timetabledLessons: timetabledLessons))
        let lessonToCover = Lesson.Monday2nd
        //act
        let actual = coverManager.getCoverOptions(teacher: Teacher(initials: "MC", department: .ComputerScience, email: "m.collins@etoncollege.org.uk"), lesson: Lesson.Monday2nd)
        //assert
        XCTAssertEqual(actual.count, 2)
        XCTAssertEqual(actual[0].coverTeacher,Teacher(initials: "DPC", department: .ComputerScience, email: "d.cormell@etoncollege.org.uk"))
        XCTAssertEqual(actual[0].lesson, lessonToCover)
        XCTAssertEqual(actual[0].room, Room.Keate1)
        XCTAssertEqual(actual[1].isReadingSchool, true)
        
    }

}

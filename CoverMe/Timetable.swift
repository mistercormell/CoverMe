//
//  Timetable.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

struct Timetable {
    var timetabledLessons: [TimetabledLesson]
    
    #if DEBUG
    static let example: [TimetabledLesson] = [TimetabledLesson(lesson: Lesson.Monday2nd, teacher: Teacher(initials: "MC"), division: Division(code: "BComV-1"), room: Room.Keate1),TimetabledLesson(lesson: Lesson.Monday2nd, teacher: Teacher(initials: "SJT"), division: Division(code: "FCom1-2"), room: Room.Birley1)]
    #endif
}

struct TimetabledLesson {
    let lesson: Lesson
    let teacher: Teacher
    let division: Division
    let room: Room
}

struct Division {
    let code: String
}

struct Teacher {
    let initials: String
}

enum Room {
    case Keate1, Keate2, Birley1, Birley2
}

enum Lesson {
    case Monday1st, Monday2nd, Monday3rd, Monday4th, Monday5th, MondayA4, MondayA5
}

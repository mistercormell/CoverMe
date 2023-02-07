//
//  Timetable.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

struct Timetable {
    var timetabledLessons: [TimetabledLesson]
    
    var team: [Teacher] {
        var workingTeam: [Teacher] = []
        for timetabledLesson in timetabledLessons {
            if !workingTeam.contains(where: { $0 == timetabledLesson.teacher}) {
                workingTeam.append(timetabledLesson.teacher)
            }
        }
        return workingTeam
    }
    
    func getRoomFor(lesson: Lesson, teacher: Teacher) -> Room? {
        let room = timetabledLessons
            .first(where: {$0.lesson == lesson && $0.teacher == teacher})
            .map({ $0.room })
        
        return room
            
    }
    
    func findAvailableTeachers(lesson: Lesson) -> Set<Teacher> {
        let availableTeachers = Set(self.team)
        let teachersTeaching = Set(self.timetabledLessons
            .filter({$0.lesson == lesson})
            .map({$0.teacher}))
        
        
        return availableTeachers.subtracting(teachersTeaching)
    }
    
    #if DEBUG
    static let example: [TimetabledLesson] = [TimetabledLesson(lesson: Lesson.Monday2nd, teacher: Teacher(initials: "MC"), division: Division(code: "BComV-1"), room: Room.Keate1),TimetabledLesson(lesson: Lesson.Monday2nd, teacher: Teacher(initials: "SJT"), division: Division(code: "FCom1-2"), room: Room.Birley1),TimetabledLesson(lesson: Lesson.Monday3rd, teacher: Teacher(initials: "DPC"), division: Division(code: "BComV-1"), room: Room.Keate2)]
    #endif
}

struct TimetabledLesson: Equatable {
    let lesson: Lesson
    let teacher: Teacher
    let division: Division
    let room: Room
}

struct Division: Equatable {
    let code: String
}

struct Teacher: Equatable, Hashable {
    let initials: String
}

enum Room: String {
    case Keate1, Keate2, Birley1, Birley2
}


enum Lesson: String, CaseIterable {
    case Monday1st, Monday2nd, Monday3rd, Monday4th, Monday5th, MondayA4, MondayA5
}
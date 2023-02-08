//
//  CoverManager.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

class CoverManager {
    let timetable: Timetable
    
    init(timetable: Timetable) {
        self.timetable = timetable
    }
    
    func getCoverOptions(teacher: Teacher, lesson: Lesson) -> [CoverArrangement] {
        var coverOptions: [CoverArrangement] = []
        if let timetabledLesson = timetable.getTimetabledLessonFor(lesson: lesson, teacher: teacher) {
            let availableTeachers = timetable.findAvailableTeachers(lesson: lesson)
            for availableTeacher in availableTeachers {
                let coverArrangement = CoverArrangement(originalTeacher: teacher, coverTeacher: availableTeacher, room: timetabledLesson.room, lesson: lesson, divisionCode: timetabledLesson.division.code, notes: "")
                coverOptions.append(coverArrangement)
            }
            return coverOptions
        } else {
            print("Couldn't find timetabled lesson for: \(teacher.initials) during \(lesson.rawValue) where cover would be due to take place")
        }

        return []
    }
}

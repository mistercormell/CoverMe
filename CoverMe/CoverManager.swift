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
        if let room = timetable.getRoomFor(lesson: lesson, teacher: teacher) {
            let availableTeachers = timetable.findAvailableTeachers(lesson: lesson)
            for availableTeacher in availableTeachers {
                let coverArrangement = CoverArrangement(teacher: availableTeacher, room: room, lesson: lesson, notes: "")
                coverOptions.append(coverArrangement)
            }
            return coverOptions
        } else {
            print("Couldn't find established room for: \(teacher.initials) during \(lesson.rawValue) where cover would be due to take place")
        }

        return []
    }
}

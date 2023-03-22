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
    
    func getBestCoverOption(teacher: Teacher, lesson: Lesson, coverTally: [Teacher: Int]) -> CoverArrangement {
        let coverOptions = getCoverOptions(teacher: teacher, lesson: lesson)
        
        if coverOptions.count == 1 {
            return coverOptions[0]
        } else {
            let teachersAvailable = Set(coverOptions.map({
                $0.coverTeacher
            }))
            let leastUtilisedAvailableTeacher = getLeastUtilisedTeacher(from: coverTally, using: teachersAvailable)
            return coverOptions.first(where: {
                $0.coverTeacher == leastUtilisedAvailableTeacher
            })! //TODO Fix this!!!
        }
    }
    
    private func getLeastUtilisedTeacher(from tally: [Teacher:Int], using teachersAvailable: Set<Teacher>) -> Teacher {
        let filteredTally = tally.filter({
            teachersAvailable.contains($0.key)
        })
        
        let entry = filteredTally.min(by: {
            $0.value < $1.value
        })
        
        //fix this! TODO!!
        return entry!.key
    }
    
    func getLessonsTaught(on date: Date, by teacher: Teacher) -> [Lesson] {
        let lessonsTaught = Lesson.allCases.filter({
            timetable.doesTeachIn($0, for: teacher)
        })
        
        let lessonsTaughtOnDate = lessonsTaught.filter({
            let currentDay = date.day
            return currentDay == $0.dayOfWeek
        })
        
        return lessonsTaughtOnDate
    }
    
    func getBestCoverOptions(date: Date, teacher: Teacher, coverTally: [Teacher:Int]) -> [CoverArrangement] {
        var bestCover: [CoverArrangement] = []
        let lessons = getLessonsTaught(on: date, by: teacher)
        
        for lesson in lessons {
            let bestOption = getBestCoverOption(teacher: teacher, lesson: lesson, coverTally: coverTally)
            bestCover.append(bestOption)
        }
        
        return bestCover
    }
    
    func getCoverOptions(date: Date, teacher: Teacher) -> [Lesson:[CoverArrangement]] {
        var coverOptions: [Lesson:[CoverArrangement]] = [:]
        let lessons = getLessonsTaught(on: date, by: teacher)
        
        for lesson in lessons {
            let coverPossibilities = getCoverOptions(teacher: teacher, lesson: lesson)
            coverOptions[lesson] = coverPossibilities
        }
        
        return coverOptions
    }
}

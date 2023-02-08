//
//  CoverPickerViewModel.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 08/02/2023.
//

import Foundation

class CoverPickerViewModel: ObservableObject {
    let timetable: Timetable
    let coverManager: CoverManager
    @Published var availableCover: [CoverArrangement] = []
    @Published var selectedLesson: Lesson = Lesson.Monday1st
    
    init() {
        let timetable = TimetableFileReader.createTimetableFromFile(filename: "timetable")
        self.timetable = timetable
        self.coverManager = CoverManager(timetable: timetable)
    }
    
    func updateAvailableCoverFor(_ teacher: Teacher, during lesson: Lesson) {
        availableCover = coverManager.getCoverOptions(teacher: teacher, lesson: lesson)
    }
    
    func getLessonsTaught(for teacherInitials: String) -> [Lesson] {
        return Lesson.allCases.filter({
            timetable.doesTeachIn($0, for: Teacher(initials: teacherInitials))
        })
    }
    
    func getTeamInitials() -> [String] {
        return timetable.team.map({ $0.initials })
    }
}

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
    @Published var selectedLesson: Lesson
    @Published var selectedTeacherInitials: String
    
    //TODO replace to dependency inject TimetableFileReader and CoverManager
    init() {
        let timetable = TimetableFileReader.createTimetableFromFile(filename: "timetable")
        self.timetable = timetable
        self.coverManager = CoverManager(timetable: timetable)
        let initialTeacher = timetable.team.first ?? Teacher(initials: "Unknown")
        let lessonsTaught = Lesson.allCases.filter({
            timetable.doesTeachIn($0, for: initialTeacher)
        })
        self.selectedTeacherInitials = initialTeacher.initials
        self.selectedLesson = lessonsTaught.first ?? Lesson.Monday2nd
    }
    
    func updateAvailableCover() {
        availableCover = coverManager.getCoverOptions(teacher: Teacher(initials: selectedTeacherInitials), lesson: selectedLesson)
    }
    
    func getLessonsTaught() -> [Lesson] {
        return Lesson.allCases.filter({
            timetable.doesTeachIn($0, for: Teacher(initials: selectedTeacherInitials))
        })
    }
    
    func getTeamInitials() -> [String] {
        return timetable.team.map({ $0.initials })
    }
}

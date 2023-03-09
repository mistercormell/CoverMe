//
//  CoverPickerViewModel.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 08/02/2023.
//

import Foundation

class CoverPickerViewModel: ObservableObject {
    static private let defaultLesson = Lesson.Monday2nd
    let timetable: Timetable
    let coverManager: CoverManager
    @Published var availableCover: [CoverArrangement] = []
    @Published var selectedLesson: Lesson
    @Published var selectedTeacherInitials: String
    @Published var selectedDate: Date = Date.now
    
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
        self.selectedLesson = lessonsTaught.first ?? CoverPickerViewModel.defaultLesson
    }
    
    func updateAvailableCover() {
        availableCover = coverManager.getCoverOptions(teacher: Teacher(initials: selectedTeacherInitials), lesson: selectedLesson)
    }
    
    func getLessonsTaughtOnDate() -> [Lesson] {
        let lessonsTaught = Lesson.allCases.filter({
            timetable.doesTeachIn($0, for: Teacher(initials: selectedTeacherInitials))
        })
        
        let lessonsTaughtOnDate = lessonsTaught.filter({
            let currentDay = selectedDate.day
            return currentDay == $0.dayOfWeek
        })
        
        return lessonsTaughtOnDate
        
    }
    
    func getAllLessonsTaught() -> [Lesson] {
        let lessonsTaught = Lesson.allCases.filter({
            timetable.doesTeachIn($0, for: Teacher(initials: selectedTeacherInitials))
        })
        if !lessonsTaught.contains(self.selectedLesson) {
            //todo fix this bug where perpetual view updates could happen
            self.selectedLesson = lessonsTaught.first ?? CoverPickerViewModel.defaultLesson
        }
        return lessonsTaught
    }
    
    func getTeamInitials() -> [String] {
        return timetable.team.map({ $0.initials })
    }
}

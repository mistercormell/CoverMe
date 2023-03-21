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
    @Published var availableCoverAllDay: [Lesson: [CoverArrangement]] = [:]
    @Published var selectedTeacherInitials: String
    @Published var selectedDate: Date = Date.now
    @Published var coverRecord: [CoverArrangementWithDate] = []
    
    //TODO replace to dependency inject TimetableFileReader and CoverManager
    init() {
        let timetable = TimetableFileReader.createTimetableFromFile(filename: "timetable")
        self.timetable = timetable
        self.coverManager = CoverManager(timetable: timetable)
        let initialTeacher = timetable.team.first ?? Teacher(initials: "Unknown")
        self.selectedTeacherInitials = initialTeacher.initials
        
    }
    
    func addCoverArrangementWithDate(cover: CoverArrangement) {
        let coverArrangementWithDate = CoverArrangementWithDate(coverArrangement: cover, date: selectedDate)
        coverRecord.append(coverArrangementWithDate)
    }
    
    func updateAvailableCoverAllDay() {
        availableCoverAllDay = coverManager.getCoverOptions(date: selectedDate, teacher: Teacher(initials: selectedTeacherInitials))
    }
    
    func getLessonDisplay(lesson: Lesson) -> String {
        timetable.getTimetabledLessonFor(lesson: lesson, teacher: Teacher(initials: selectedTeacherInitials))?.display ?? ""
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
    
    func confirmCover(_ cover: CoverArrangementWithDate) {
        cover.confirm()
        objectWillChange.send()
    }
    
    func removeCoverFromRecord(_ cover: CoverArrangementWithDate) {
        coverRecord.removeAll(where: {
            $0 == cover
        })
    }
    
    func getTeamInitials() -> [String] {
        return timetable.team.map({ $0.initials })
    }
    
//    func saveCoverRecord() {
//        FileManager.default.save(to: "coverRecord.json", object: coverRecord)
//    }
//    
//    func restoreDraftCoverRecord() {
//        
//    }
}

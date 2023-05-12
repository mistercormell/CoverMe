//
//  CoverPickerViewModel.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 08/02/2023.
//

import Foundation
import ParseSwift

class CoverPickerViewModel: ObservableObject {
    static private let defaultLesson = Lesson.Monday2nd
    let timetable: Timetable
    let termDates: TermDates
    let coverManager: CoverManager
    var coverRecordDaoObjectId: String?
    @Published var availableCoverAllDay: [Lesson: [CoverArrangement]] = [:]
    @Published var selectedTeacherInitials: String
    @Published var selectedDate: Date = Date.now
    @Published var selectedDepartment: Department //default subject!
    @Published var coverRecord: [CoverArrangementWithDate] = [] {
        didSet {
            self.saveCoverRecord()
        }
    }
    
    //TODO replace to dependency inject TimetableFileReader and CoverManager
    init(selectedDepartment: Department) {
        let timetable = TimetableFileReader.createTimetableFromFile(filename: "timetable")
        self.timetable = timetable
        self.coverManager = CoverManager(timetable: timetable)
        self.selectedDepartment = selectedDepartment
        let initialTeacher = timetable.getTeam(by: selectedDepartment).first ?? Teacher(initials: "Unknown", department: selectedDepartment)
        self.selectedTeacherInitials = initialTeacher.initials
        let termDates = TermDatesFileReader.createTermDatesFromFile(filename: "termdates")
        self.termDates = termDates
        
    }
    
    func addAutogeneratedCover() {
        let bestCoverOptions = coverManager.getBestCoverOptions(date: selectedDate, teacher: Teacher(initials: selectedTeacherInitials, department: selectedDepartment), coverTally: getCoverTally())
        for cover in bestCoverOptions {
            addCoverArrangementWithDate(cover: cover)
        }
    }
    
    func addCoverArrangementWithDate(cover: CoverArrangement) {
        let coverArrangementWithDate = CoverArrangementWithDate(coverArrangement: cover, date: selectedDate, inSummer: termDates.isSummer(at: selectedDate))
        coverRecord.append(coverArrangementWithDate)
    }
    
    func updateAvailableCoverAllDay() {
        availableCoverAllDay = coverManager.getCoverOptions(date: selectedDate, teacher: Teacher(initials: selectedTeacherInitials, department: selectedDepartment))
    }
    
    func getLessonDisplay(lesson: Lesson) -> String {
        let timetabledLesson = timetable.getTimetabledLessonFor(lesson: lesson, teacher: Teacher(initials: selectedTeacherInitials, department: selectedDepartment))
        
        return CoverArrangementWithDate.getDisplay(text: timetabledLesson?.display ?? "", inSummer: termDates.isSummer(at: selectedDate))
    }
    
    func getLessonsTaughtOnDate() -> [Lesson] {
        let lessonsTaught = Lesson.allCases.filter({
            timetable.doesTeachIn($0, for: Teacher(initials: selectedTeacherInitials, department: selectedDepartment))
        })
        
        let lessonsTaughtOnDate = lessonsTaught.filter({
            let currentDay = selectedDate.day
            return currentDay == $0.dayOfWeek
        })
        
        return lessonsTaughtOnDate
        
    }
    
    func confirmCover(_ cover: CoverArrangementWithDate) {
        cover.confirm()
        self.saveCoverRecord()
        objectWillChange.send()
    }
    
    func removeCoverFromRecord(_ cover: CoverArrangementWithDate) {
        coverRecord.removeAll(where: {
            $0 == cover
        })
    }
    
    func getTeamInitials() -> [String] {
        return timetable.getTeam(by: selectedDepartment).map({ $0.initials })
    }
    
    func getCoverTally() -> [Teacher:Int] {
        var dictionary: [Teacher:Int] = [:]
        let confirmedCover = coverRecord.filter({
            $0.status == .confirmed && $0.coverArrangement.isReadingSchool == false
        })
        
        for teacher in timetable.getTeam(by: selectedDepartment) {
            dictionary[teacher] = 0
        }
    
        for cover in confirmedCover {
            dictionary[cover.coverArrangement.coverTeacher]! += 1
        }
        
        return dictionary
    }
    
    func getCoverTallyBreakdown() -> [(Teacher, Tally)] {
        var teacherTally: [(Teacher, Tally)] = []
        let confirmedCover = coverRecord.filter({
            $0.status == .confirmed && $0.coverArrangement.isReadingSchool == false
        })
        
        for teacher in timetable.getTeam(by: selectedDepartment) {
            let global = confirmedCover.filter({$0.coverArrangement.coverTeacher == teacher}).count
            let currentHalf = confirmedCover.filter({$0.coverArrangement.coverTeacher == teacher && termDates.getTermDisplay(for: $0.date) == termDates.getTermDisplay(for: Date.now.startOfDayDate)}).count
            
            teacherTally.append((teacher, Tally(currentHalf: currentHalf, allTime: global)))
        }
        
        return teacherTally
    }
    
    func getReadingSchoolTally() -> Int {
        return coverRecord.filter({
            $0.coverArrangement.isReadingSchool
        }).count
    }
    
    func getReadingSchoolTallyBreakdown() -> (Int, Int) {
        let currentHalfReaders = coverRecord.filter({
            $0.coverArrangement.isReadingSchool && termDates.getTermDisplay(for: $0.date) == termDates.getTermDisplay(for: Date.now.startOfDayDate)
        }).count
        
        let allTimeReaders = getReadingSchoolTally()
        
        return (currentHalfReaders, allTimeReaders)
    }
    
    func getTallyDisplay(for cover: CoverArrangement) -> Int {
        let tally = getCoverTally()
        if cover.isReadingSchool {
            return getReadingSchoolTally()
        } else {
            return tally[cover.coverTeacher] ?? 0
        }
    }
    
    func saveCoverRecord() {
        FileManager.default.save(to: "coverRecord.json", object: coverRecord)
        if let json = FileManager.default.getJson(object: coverRecord) {
            if let objectId = coverRecordDaoObjectId {
                var itemToUpdate = DepartmentCoverDao(objectId: objectId)
                itemToUpdate.json = json
                itemToUpdate.save { result in
                    print("Item with \(objectId) just saved in cloud")
                }
            } else {
                var coverRecordDao = DepartmentCoverDao(departmentName: selectedDepartment.rawValue, json: json)
                coverRecordDao.save { result in
                    print("Item saved to the cloud for the first time")
                    self.coverRecordDaoObjectId = try? result.get().objectId
                }
            }

        }
    }
    
    func restoreCoverRecord() {
        if let loadedCoverRecord: [CoverArrangementWithDate] = FileManager.default.load(from: "coverRecord.json") {
            coverRecord = loadedCoverRecord
        } else {
            let constraint: QueryConstraint = "departmentName" == selectedDepartment.rawValue
            let query = DepartmentCoverDao.query(constraint).order([.descending("updatedAt")])
            
            let departmentCoverDaos = try? query.find()
            if let departmentCoverDaoJson = departmentCoverDaos?.first?.json {
                if let loadedCoverRecord: [CoverArrangementWithDate] = FileManager.default.deserializeJson(from: departmentCoverDaoJson) {
                    coverRecord = loadedCoverRecord
                }
            }
        }
    }
}

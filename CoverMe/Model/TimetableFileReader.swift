//
//  TimetableFileReader.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

class TimetableFileReader {
    static func getTeacher(by initials: String, teachers: [Teacher]) -> Teacher {
        if let teacher = teachers.first(where: {$0.initials == initials}) {
            return teacher
        } else {
            print("Failed to get teacher from initials \(initials)")
            return Teacher.dummy
        }
    }
    
    static func createTimetabledLessonFromLine(line: String, teachers: [Teacher]) -> TimetabledLesson? {
        let parts = line.components(separatedBy: ",")
        if let lesson = Lesson(rawValue: parts[0]) {
            let timetabledLesson = TimetabledLesson(lesson: lesson, teacher: getTeacher(by: parts[3], teachers: teachers), faculty: Faculty(rawValue: parts[1]) ?? .unknown, division: Division(code: parts[2]), room: parts[4])
            return timetabledLesson
        } else {
            print("Invalid lesson code")
        }
        return nil
    }
    
    static func initialiseTimetableAndStaffData() -> (Timetable,[Teacher]) {
        let teachers = getStaffFromFile()
        
        return (createTimetableFromFileWithTeachers(teachers: teachers), teachers)
    }
    
    static func createTimetableFromFileWithTeachers(teachers: [Teacher]) -> Timetable {
        if let fileUrl = TimetableDataStore.shared.timetableUrl {
            do {
                let contents = try String(contentsOf: fileUrl)
                let lines = contents.components(separatedBy: "\n")
                var timetabledLessons: [TimetabledLesson] = []
                for line in lines {
                    if line.isEmpty { continue }
                    if let timetabledLesson = createTimetabledLessonFromLine(line: line, teachers: teachers) {
                        timetabledLessons.append(timetabledLesson)
                    } else {
                        print("Error, could not extract valid timetabled lesson from: \(line)")
                    }
                }
                return Timetable(timetabledLessons: timetabledLessons, teachers: teachers)
            } catch {
                print("Couldn't load contents of file")
            }
        } else {
            print("File not found!")
        }
        
        return Timetable(timetabledLessons: [], teachers: [])
    }
    
    static func createTeacherFromLine(line: String) -> Teacher? {
        let parts = line.components(separatedBy: ",")
        let faculties = parts[1].components(separatedBy: "-")
            .map({
                Faculty(rawValue: $0) ?? .unknown
            })
        
        if faculties.contains(.unknown) {
            return nil
        }
        
        let teacher = Teacher(initials: parts[0], faculties: faculties, email: parts[2])
        return teacher
    }
    
    static func getStaffFromFile() -> [Teacher] {
        if let fileUrl = TimetableDataStore.shared.staffingUrl {
            do {
                let contents = try String(contentsOf: fileUrl)
                let lines = contents.components(separatedBy: "\n")
                var allStaff: [Teacher] = []
                for line in lines {
                    if !line.isEmpty {
                        if let teacher = createTeacherFromLine(line: line) {
                            allStaff.append(teacher)
                        } else {
                            print("Error, could not extract valid staff member from: \(line)")
                        }
                    }
                }
                return allStaff
            } catch {
                print("Couldn't load contents of staff file")
            }
        } else {
            print("File not found! (staffing)")
        }
        
        return []
    }
    
}

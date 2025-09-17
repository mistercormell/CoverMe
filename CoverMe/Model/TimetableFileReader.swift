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
            let timetabledLesson = TimetabledLesson(lesson: lesson, teacher: getTeacher(by: parts[2], teachers: teachers), division: Division(code: parts[1]), room: parts[3])
            return timetabledLesson
        } else {
            print("Invalid lesson code")
        }
        return nil
    }
    
    static func initialiseTimetableAndStaffData() -> (Timetable,[Teacher]) {
        let teachers = getStaffFromFile(filename: "staff")
        
        return (createTimetableFromFileWithTeachers(filename: "timetable", teachers: teachers), teachers)
    }
    
    static func createTimetableFromFileWithTeachers(filename: String, teachers: [Teacher]) -> Timetable {
        if let filepath = Bundle.main.path(forResource: filename, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
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
        if let department = Department(rawValue: parts[1]) {
            let teacher = Teacher(initials: parts[0], department: department, email: parts[2])
            return teacher
        } else {
            print("Invalid teacher's department")
        }
        return nil
    }
    
    static func getStaffFromFile(filename: String) -> [Teacher] {
        if let filepath = Bundle.main.path(forResource: filename, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
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

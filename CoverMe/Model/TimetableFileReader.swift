//
//  TimetableFileReader.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

class TimetableFileReader {
    static private func getDepartment(from divisionCode: String) -> Department {
        if divisionCode.contains("Com") {
            return .ComputerScience
        } else if divisionCode.contains("Div") || divisionCode.contains("The") {
            return .Divinity
        } else if divisionCode.contains("His") || divisionCode.contains("Hmn") || divisionCode.contains("Hml") || divisionCode.contains("Hem") || divisionCode.contains("Hoa") || divisionCode.contains("Art") || divisionCode.contains("Opt") || divisionCode.contains("Eng") || divisionCode.contains("Spr") {
            return .History
        } else if divisionCode == "NotAvailable" {
            if divisionCode.contains("History") {
                return .History
            } else {
                return .ComputerScience
            }
        } else {
            return .ComputerScience
        }
    }
    
    static func createTimetabledLessonFromLine(line: String) -> TimetabledLesson? {
        let parts = line.components(separatedBy: ",")
        if let lesson = Lesson(rawValue: parts[0]) {
            if let room = Room(rawValue: parts[3]) {
                let timetabledLesson = TimetabledLesson(lesson: lesson, teacher: Teacher(initials: parts[2], department: getDepartment(from: parts[1])), division: Division(code: parts[1]), room: room)
                return timetabledLesson
            } else {
                print("Invalid room name")
            }
        } else {
            print("Invalid lesson code")
        }
        return nil
    }
    
    static func createTimetableFromFile(filename: String) -> Timetable {
        if let filepath = Bundle.main.path(forResource: filename, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let lines = contents.components(separatedBy: "\n")
                var timetabledLessons: [TimetabledLesson] = []
                for line in lines {
                    if let timetabledLesson = createTimetabledLessonFromLine(line: line) {
                        timetabledLessons.append(timetabledLesson)
                    } else {
                        print("Error, could not extract valid timetabled lesson from: \(line)")
                    }
                }
                return Timetable(timetabledLessons: timetabledLessons)
            } catch {
                print("Couldn't load contents of file")
            }
        } else {
            print("File not found!")
        }
        
        return Timetable(timetabledLessons: [])
    }
    
    static func createTeacherFromLine(line: line) -> Teacher? {
        let parts = line.components(separatedBy: ",")
        if let department = Department(rawValue: parts[1]) {
            let teacher = Teacher(initials: parts[0], department: department)
            return teacher
        } else {
            print("Invalid room name")
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
                    if let teacher = createTeacherFromLine(line: line) {
                        allStaff.append(teacher)
                    } else {
                        print("Error, could not extract valid timetabled lesson from: \(line)")
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

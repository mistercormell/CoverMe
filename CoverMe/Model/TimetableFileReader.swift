//
//  TimetableFileReader.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

class TimetableFileReader {
    static func createTimetabledLessonFromLine(line: String) -> TimetabledLesson? {
        let parts = line.components(separatedBy: ",")
        if let lesson = Lesson(rawValue: parts[0]) {
            if let room = Room(rawValue: parts[3]) {
                let timetabledLesson = TimetabledLesson(lesson: lesson, teacher: Teacher(initials: parts[2]), division: Division(code: parts[1]), room: room)
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
    
}

//
//  TermDatesFileReader.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 28/04/2023.
//

import Foundation

class TermDatesFileReader {
    static func createTermDatesFromFile() -> TermDates {
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
        return TermDates()
    }
}

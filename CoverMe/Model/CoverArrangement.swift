//
//  CoverArrangement.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

struct LessonCoverPossibilities {
    let lesson: Lesson
    let coverPossibilities: [CoverArrangement]
}

enum CoverStatus: String, Codable {
    case draft, confirmed
}

struct CoverTally {
    let teacher: Teacher
    let count: Int
}

class CoverArrangementWithDate: Identifiable, Comparable, Codable {
    let coverArrangement: CoverArrangement
    let date: Date
    let inSummer: Bool
    var status: CoverStatus
    
    init(coverArrangement: CoverArrangement, date: Date, inSummer: Bool) {
        self.coverArrangement = coverArrangement
        self.date = date
        self.status = .draft
        self.inSummer = inSummer
    }
    
    static func == (lhs: CoverArrangementWithDate, rhs: CoverArrangementWithDate) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: CoverArrangementWithDate, rhs: CoverArrangementWithDate) -> Bool {
        if lhs.startOfDayDate < rhs.startOfDayDate {
            return true
        } else if lhs.startOfDayDate == rhs.startOfDayDate {
            return lhs.coverArrangement.lesson < rhs.coverArrangement.lesson
        } else {
            return false
        }
    }
    
    //TODO - change so that this is unique with a given date (won't have this issue for a while)
    var id: String {
        "\(coverArrangement.id)-\(date.description)"
    }
    
    var display: String {
        "\(date.longDateDescription): \(CoverArrangementWithDate.getDisplay(text: coverArrangement.display, inSummer: inSummer))"
    }
    
    var displayWithoutDate: String {
        "\(CoverArrangementWithDate.getDisplay(text: coverArrangement.display, inSummer: inSummer))"
    }
    
    var startOfDayDate: Date {
        Calendar.current.startOfDay(for: date)
    }
    
    func confirm() {
        self.status = .confirmed
    }
    
    static func getDisplay(text: String, inSummer: Bool) -> String {
        var sixth = "A4"
        var seventh = "A5"
        if inSummer {
            sixth = "A3"
            seventh = "A4"
        }
        let display = text.replacingOccurrences(of: "6th", with: sixth)
        return display.replacingOccurrences(of: "7th", with: seventh)
    }
}

struct CoverArrangement: Identifiable, Codable {
    let originalTeacher: Teacher
    let coverTeacher: Teacher
    let room: Room
    let lesson: Lesson
    let divisionCode: String
    let notes: String
    let isReadingSchool: Bool
    
    var id: String {
        "\(self.originalTeacher.initials)\(self.coverTeacher.initials)-\(self.room.rawValue)-\(self.lesson.rawValue)"
    }
    
    var display: String {
        "\(toBeCoveredDisplay) - \(coverOptionDisplay)"
    }
        
    var toBeCoveredDisplay: String {
        "\(lesson.displayName) - \(divisionCode) (\(originalTeacher.initials))"
    }
    
    var coverOptionDisplay: String {
        if isReadingSchool {
            return "Reader to be given"
        } else {
            return "\(coverTeacher.initials) to cover in \(room.displayName)"
        }
        
    }
}

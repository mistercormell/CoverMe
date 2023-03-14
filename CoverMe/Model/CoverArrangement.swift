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

struct CoverArrangementWithDate: Identifiable {
    let coverArrangement: CoverArrangement
    let date: Date
    
    //TODO - change so that this is unique with a given date (won't have this issue for a while)
    var id: String {
        "\(coverArrangement.id)-\(date.description)"
    }
    
    var startOfDayDate: Date {
        Calendar.current.startOfDay(for: date)
    }
}

struct CoverArrangement: Identifiable {
    let originalTeacher: Teacher
    let coverTeacher: Teacher
    let room: Room
    let lesson: Lesson
    let divisionCode: String
    let notes: String
    
    var id: String {
        "\(self.originalTeacher.initials)\(self.coverTeacher.initials)-\(self.room.rawValue)-\(self.lesson.rawValue)"
    }
    
    var display: String {
        "\(shortDisplay) to cover in \(room.displayName)"
    }
    
    var shortDisplay: String {
        "\(lesson.displayName) - \(divisionCode) (\(originalTeacher.initials)) - \(coverTeacher.initials)"
    }
    
    var toBeCoveredDisplay: String {
        "\(lesson.displayName) - \(divisionCode) (\(originalTeacher.initials))"
    }
    
    var coverOptionDisplay: String {
        "\(coverTeacher.initials) to cover in \(room.displayName)"
    }
}

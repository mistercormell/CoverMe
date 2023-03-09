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

struct CoverArrangement: Identifiable {
    let originalTeacher: Teacher
    let coverTeacher: Teacher
    let room: Room
    let lesson: Lesson
    let divisionCode: String
    let notes: String
    
    var id: String {
        "\(self.coverTeacher.initials)-\(self.room.rawValue)-\(self.lesson.rawValue)"
    }
    
    var display: String {
        "\(lesson.displayName) - \(divisionCode) (\(originalTeacher.initials)) - \(coverTeacher.initials) to cover in \(room.displayName)"
    }
    
    var toBeCoveredDisplay: String {
        "\(lesson.displayName) - \(divisionCode) (\(originalTeacher.initials))"
    }
    
    var coverOptionDisplay: String {
        "\(coverTeacher.initials) to cover in \(room.displayName)"
    }
}

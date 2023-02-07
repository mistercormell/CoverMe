//
//  CoverArrangement.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

struct CoverArrangement: Identifiable {
    let teacher: Teacher
    let room: Room
    let lesson: Lesson
    let notes: String
    
    var id: String {
        "\(self.teacher.initials)-\(self.room.rawValue)-\(self.lesson.rawValue)"
    }
}

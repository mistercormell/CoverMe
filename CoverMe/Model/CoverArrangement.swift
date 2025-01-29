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
    let timetableTiming: TimetableTiming
    var status: CoverStatus
    
    init(coverArrangement: CoverArrangement, date: Date, timetableTiming: TimetableTiming) {
        self.coverArrangement = coverArrangement
        self.date = date
        self.status = .draft
        self.timetableTiming = timetableTiming
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
        "\(date.longDateDescription): \(CoverArrangementWithDate.getDisplay(text: coverArrangement.display, timetableTiming: timetableTiming))"
    }
    
    var displayWithoutDate: String {
        "\(CoverArrangementWithDate.getDisplay(text: coverArrangement.display, timetableTiming: timetableTiming))"
    }
    
    var startOfDayDate: Date {
        Calendar.current.startOfDay(for: date)
    }
    
    func confirm() {
        self.status = .confirmed
    }
    
    static func getDisplay(text: String, timetableTiming: TimetableTiming) -> String {
        var sixth = "A4"
        var seventh = "A5"
        if timetableTiming == .Summer {
            sixth = "A3"
            seventh = "A4"
        } else if timetableTiming == .EarlyMichaelmas {
            sixth = "A2"
            seventh = "A3"
        }
        let display = text.replacingOccurrences(of: "6th", with: sixth)
        return display.replacingOccurrences(of: "7th", with: seventh)
    }
}

enum ReasonForCover: String, Codable, CaseIterable {
    case health = "Health"
    case personal = "Personal"
    case partnerships = "Partnerships"
    case coCurricular = "Co-curricular" 
    case training = "Training"
    case otherSchoolCommitment = "Other School Commitment"
    case outsideInterest = "Outside Interest"
    
    var iconName: String {
        switch self {
        case .health:
            return "medical.thermometer"
        case .personal:
            return "person"
        case .partnerships:
            return "figure.2.and.child.holdinghands"
        case .coCurricular:
            return "tennis.racket"
        case .training:
            return "graduationcap"
        case .outsideInterest:
            return "figure.walk.departure"
        default:
            return "questionmark.circle"
        }
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
    let reasonForCover: ReasonForCover?
    let isShared: Bool
    
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
    
    init(originalTeacher: Teacher,
         coverTeacher: Teacher,
         room: Room,
         lesson: Lesson,
         divisionCode: String,
         notes: String,
         isReadingSchool: Bool,
         reasonForCover: ReasonForCover?,
         isShared: Bool) {
        self.originalTeacher = originalTeacher
        self.coverTeacher = coverTeacher
        self.room = room
        self.lesson = lesson
        self.divisionCode = divisionCode
        self.notes = notes
        self.isReadingSchool = isReadingSchool
        self.reasonForCover = reasonForCover
        self.isShared = isShared
    }
    
    // Custom Decodable Implementation
    enum CodingKeys: String, CodingKey {
        case originalTeacher, coverTeacher, room, lesson, divisionCode, notes, isReadingSchool, reasonForCover, isShared
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.originalTeacher = try container.decode(Teacher.self, forKey: .originalTeacher)
        self.coverTeacher = try container.decode(Teacher.self, forKey: .coverTeacher)
        self.room = try container.decode(Room.self, forKey: .room)
        self.lesson = try container.decode(Lesson.self, forKey: .lesson)
        self.divisionCode = try container.decode(String.self, forKey: .divisionCode)
        self.notes = try container.decode(String.self, forKey: .notes)
        self.isReadingSchool = try container.decode(Bool.self, forKey: .isReadingSchool)
        self.reasonForCover = try container.decodeIfPresent(ReasonForCover.self, forKey: .reasonForCover)
        self.isShared = try container.decodeIfPresent(Bool.self, forKey: .isShared) ?? false
    }
}

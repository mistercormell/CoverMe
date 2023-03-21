//
//  Timetable.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

struct Timetable {
    var timetabledLessons: [TimetabledLesson]
    
    var team: [Teacher] {
        var workingTeam: [Teacher] = []
        for timetabledLesson in timetabledLessons {
            if !workingTeam.contains(where: { $0 == timetabledLesson.teacher}) {
                workingTeam.append(timetabledLesson.teacher)
            }
        }
        return workingTeam
    }
    
    func getTimetabledLessonFor(lesson: Lesson, teacher: Teacher) -> TimetabledLesson? {
        let timetabledLesson = timetabledLessons
            .first(where: {$0.lesson == lesson && $0.teacher == teacher})
        
        return timetabledLesson
            
    }

    func doesTeachIn(_ lesson: Lesson, for teacher: Teacher) -> Bool {
        for timetabledLesson in timetabledLessons {
            if timetabledLesson.teacher == teacher && timetabledLesson.lesson == lesson {
                return true
            }
        }
        return false
    }

    //TODO - potentially remove as unused now as just getting the room is unhelpful
    func getRoomFor(lesson: Lesson, teacher: Teacher) -> Room? {
        let room = timetabledLessons
            .first(where: {$0.lesson == lesson && $0.teacher == teacher})
            .map({ $0.room })
        
        return room
            
    }
    
    func findAvailableTeachers(lesson: Lesson) -> Set<Teacher> {
        let availableTeachers = Set(self.team)
        let teachersTeaching = Set(self.timetabledLessons
            .filter({$0.lesson == lesson})
            .map({$0.teacher}))
        
        
        return availableTeachers.subtracting(teachersTeaching)
    }
    
    #if DEBUG
    static let example: [TimetabledLesson] = [TimetabledLesson(lesson: Lesson.Monday2nd, teacher: Teacher(initials: "MC"), division: Division(code: "BComV-1"), room: Room.Keate1),TimetabledLesson(lesson: Lesson.Monday2nd, teacher: Teacher(initials: "SJT"), division: Division(code: "FCom1-2"), room: Room.Birley1),TimetabledLesson(lesson: Lesson.Monday3rd, teacher: Teacher(initials: "DPC"), division: Division(code: "BComV-1"), room: Room.Keate2)]
    #endif
}

struct TimetabledLesson: Equatable {
    let lesson: Lesson
    let teacher: Teacher
    let division: Division
    let room: Room
    
    var display: String {
        "\(lesson.displayName) - \(division.code) (\(teacher.initials))"
    }
}

struct Division: Equatable {
    let code: String
}

struct Teacher: Equatable, Hashable, Codable, Comparable {
    static func < (lhs: Teacher, rhs: Teacher) -> Bool {
        return lhs.initials < rhs.initials
    }
    
    let initials: String

    func getEmail() -> String {
        if initials == "SJT" {
            return "s.tebbutt@etoncollege.org.uk"
        } else if initials == "MC" {
            return "m.collins@etoncollege.org.uk"
        } else if initials == "JWFS" {
            return "j.stanforth@etoncollege.org.uk"
        } else if initials == "SKG" {
            return "s.grover@etoncollege.org.uk"
        } else {
            return "d.cormell@etoncollege.org.uk"
        }
                
    }
}

enum Room: String, Codable {
    case Keate1, Keate2, Birley1, Birley2
    
    var displayName: String {
        if self.rawValue.hasSuffix("1") {
            return "1 \(self.rawValue.prefix(self.rawValue.count-1))"
        } else if self.rawValue.hasSuffix("2") {
            return "2 \(self.rawValue.prefix(self.rawValue.count-1))"
        } else {
            return self.rawValue
        }
    }
}


enum Lesson: String, CaseIterable, Hashable, Comparable, Codable {
    static func < (lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.comparisonValue < rhs.comparisonValue
    }
    
    case Monday1st, Monday2nd, Monday3rd, Monday4th, Monday5th, MondayA4, MondayA5,Tuesday1st,Tuesday2nd,Tuesday3rd,Tuesday4th,Tuesday5th,Wednesday1st, Wednesday2nd, Wednesday3rd, Wednesday4th, Wednesday5th, WednesdayA4, WednesdayA5,Thursday1st,Thursday2nd,Thursday3rd,Thursday4th,Thursday5th,Friday1st, Friday2nd, Friday3rd, Friday4th, Friday5th, FridayA4, FridayA5,Saturday1st,Saturday2nd,Saturday3rd,Saturday4th
    
    //this needs replacing, perhaps enum no longer fit for Lessons now...
    private var comparisonValue: Int {
      switch self {
      case .Monday1st:
        return 1
      case .Monday2nd:
        return 2
      case .Monday3rd:
        return 3
      case .Monday4th:
        return 4
      case .Monday5th:
        return 5
      case .MondayA4:
        return 6
      case .MondayA5:
        return 7
      case .Tuesday1st:
        return 8
      case .Tuesday2nd:
        return 9
      case .Tuesday3rd:
        return 10
      case .Tuesday4th:
        return 11
      case .Tuesday5th:
        return 12
      case .Wednesday1st:
        return 13
      case .Wednesday2nd:
        return 14
      case .Wednesday3rd:
        return 15
      case .Wednesday4th:
        return 16
      case .Wednesday5th:
        return 17
      case .WednesdayA4:
        return 18
      case .WednesdayA5:
        return 19
      case .Thursday1st:
        return 20
      case .Thursday2nd:
        return 21
      case .Thursday3rd:
        return 22
      case .Thursday4th:
        return 23
      case .Thursday5th:
        return 24
      case .Friday1st:
        return 25
      case .Friday2nd:
        return 26
      case .Friday3rd:
        return 27
      case .Friday4th:
        return 28
      case .Friday5th:
        return 29
      case .FridayA4:
        return 30
      case .FridayA5:
        return 31
      case .Saturday1st:
        return 32
      case .Saturday2nd:
        return 33
      case .Saturday3rd:
        return 34
      case .Saturday4th:
        return 35

      }
    }
    
    //adds a space between the day of the week and the school in that day
    var displayName: String {
        if let locationOfY = self.rawValue.firstIndex(of: "y") {
            var display = self.rawValue
            display.insert(" ", at: display.index(locationOfY, offsetBy: 1))
            return display
        } else {
            return self.rawValue
        }
    }
    
    var dayOfWeek: String {
        if let locationOfY = self.rawValue.firstIndex(of: "y") {
            return String(self.rawValue.prefix(upTo: locationOfY)) + "y"
        } else {
            return self.rawValue
        }
    }
}

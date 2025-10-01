//
//  Timetable.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import Foundation

struct Timetable {
    var timetabledLessons: [TimetabledLesson]
    var teachers: [Teacher]
    
    var timetabledStaff: [Teacher] {
        var workingTeam: [Teacher] = []
        for timetabledLesson in timetabledLessons {
            if !workingTeam.contains(where: { $0 == timetabledLesson.teacher}) {
                workingTeam.append(timetabledLesson.teacher)
            }
        }
        return workingTeam
    }
    
    func getTimetabledTeam(by department: Department) -> [Teacher] {
        return timetabledStaff.filter({ $0.departments.contains(department) })
    }
    
    //this is required because it is possible that there could be a member of a department who isn't timetabled for any schools, but might do cover (e.g. a Graduate Teacher)
    func getTeam(by department: Department) -> [Teacher] {
        return teachers.filter({ $0.departments.contains(department) })
    }

    func getTimetabledLessonFor(lesson: Lesson, teacher: Teacher) -> TimetabledLesson? {
        let timetabledLesson = timetabledLessons
            .first(where: {$0.lesson == lesson && $0.teacher == teacher})
        
        return timetabledLesson
            
    }

    func doesTeachIn(_ lesson: Lesson, for teacher: Teacher) -> Bool {
        for timetabledLesson in timetabledLessons {
            if timetabledLesson.teacher == teacher && timetabledLesson.lesson == lesson && timetabledLesson.division.code != "NotAvailable" {
                return true
            }
        }
        return false
    }
    
    func doesShareDivision(teacher: Teacher, division: Division) -> Bool {
        return timetabledLessons.filter {
            $0.teacher == teacher
        }
        .map({
            $0.division
        })
        .contains(where: {
            $0.code == division.code
        })
        
    
    }

    //TODO - potentially remove as unused now as just getting the room is unhelpful
    func getRoomFor(lesson: Lesson, teacher: Teacher) -> String? {
        let room = timetabledLessons
            .first(where: {$0.lesson == lesson && $0.teacher == teacher})
            .map({ $0.room })
        
        return room
            
    }
    
    func findAvailableTeachers(lesson: Lesson) -> Set<Teacher> {
        let availableTeachers = Set(self.timetabledStaff)
        let teachersTeaching = Set(self.timetabledLessons
            .filter({$0.lesson == lesson})
            .map({$0.teacher}))
        
        
        return availableTeachers.subtracting(teachersTeaching)
    }
    
    #if DEBUG
    static let example: [TimetabledLesson] = [TimetabledLesson(lesson: Lesson.Monday2nd, teacher: Teacher(initials: "MC", faculties: [.computerScience], email: "m.collins@etoncollege.org.uk"), faculty: .computerScience, division: Division(code: "BComV-1"), room: "1 Keate"),TimetabledLesson(lesson: Lesson.Monday2nd, teacher: Teacher(initials: "SJT", faculties: [.computerScience], email: "s.tebbutt@etoncollege.org.uk"), faculty: .computerScience, division: Division(code: "FCom1-2"), room: "1 Birley"),TimetabledLesson(lesson: Lesson.Monday3rd, teacher: Teacher(initials: "DPC", faculties: [.computerScience], email: "d.cormell@etoncollege.org.uk"), faculty: .computerScience, division: Division(code: "BComV-1"), room: "2 Keate")]
    #endif
}

struct TimetabledLesson: Equatable {
    let lesson: Lesson
    let teacher: Teacher
    let faculty: Faculty
    let division: Division
    let room: String
    
    var display: String {
        "\(lesson.displayName) - \(division.code) (\(teacher.initials))"
    }
    
    func canBeGivenReader() -> Bool {
        if division.code.hasPrefix("C") || division.code.hasPrefix("B") {
            if lesson.canBeGivenReader {
                return true
            }
        }
        
        return false
    }
}

struct Division: Equatable {
    let code: String
}

enum Faculty: String, Codable {
    case arabic = "Ara"
    case ancientHistory = "Ahy"
    case art = "Art"
    case biology = "Bio"
    case classicalCivilisation = "Ccv"
    case chemistry = "Che"
    case chinese = "Chi"
    case computerScience = "Com"
    case design = "Des"
    case divinity = "Div"
    case drama = "Dra"
    case economics = "Eco"
    case english = "Eng"
    case french = "Fre"
    case geography = "Geo"
    case german = "Ger"
    case greek = "Grk"
    case history = "His"
    case historyEarlyModern = "Hem"
    case historyModern = "Hmn"
    case historyMedieval = "Hml"
    case historyOfArt = "Hoa"
    case italian = "Ita"
    case japanese = "Jpn"
    case latin = "Lat"
    case maths = "Mat"
    case mathsFurtherPure = "Mdp"
    case mathsFurtherApplied = "Mda"
    case musicRe = "Mre"
    case mathsSingle = "Msi"
    case music = "Mus"
    case musicTech = "Mut"
    case option = "Opt"
    case physicalEducation = "Ped"
    case physics = "Phy"
    case politics = "Pol"
    case russian = "Rus"
    case spanish = "Spn"
    case sphere = "Spr"
    case theology = "The"
    case learningSupport = "Ls"
    case careerEducation = "Car"
    case unknown

    var department: Department? {
        Department.allCases.first { $0.faculties.contains(self) }
    }
}



enum Department: String, Codable, CaseIterable {
    case history
    case computerScience
    case modernLanguages
    case divinity
    case classics
    case english
    case biology
    case physics
    case chemistry
    case maths
    case music
    case politics
    case economics
    case sphere
    case art
    case drama
    case pe
    case option
    case geography
    case design
    case learningSupport
    case careerEducation
    
    var displayName: String {
        // Insert a space before each capital letter
        let withSpaces = rawValue
            .replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression)
        
        // Capitalise first letter
        return withSpaces.capitalized
    }
    
    var faculties: [Faculty] {
        switch self {
        case .english: return [.english]
        case .physics: return [.physics]
        case .chemistry: return [.chemistry]
        case .biology: return [.biology]
        case .maths: return [.maths, .mathsSingle, .mathsFurtherPure, .mathsFurtherApplied]
        case .music: return [.music, .musicRe, .musicTech]
        case .history: return [.history, .historyModern, .historyEarlyModern, .historyMedieval, .historyOfArt]
        case .computerScience: return [.computerScience]
        case .modernLanguages: return [.arabic, .french, .german, .italian, .russian, .spanish, .japanese, .chinese]
        case .divinity: return [.divinity, .theology]
        case .classics: return [.latin, .greek, .classicalCivilisation, .ancientHistory]
        case .drama: return [.drama]
        case .politics: return [.politics]
        case .economics: return [.economics]
        case .sphere: return [.sphere]
        case .art: return [.art]
        case .pe: return [.physicalEducation]
        case .option: return [.option]
        case .geography: return [.geography]
        case .design: return [.design]
        case .learningSupport: return [.learningSupport]
        case .careerEducation: return [.careerEducation]
        }
    }
}

struct Tally {
    let currentHalf: Int
    let allTime: Int
}

struct CoverStatistic {
    let currentHalf: Int
    let previousHalf: Int
    let priorToPreviousHalf: Int
    let allTime: Int
}

struct Teacher: Equatable, Hashable, Codable, Comparable {
    static func < (lhs: Teacher, rhs: Teacher) -> Bool {
        return lhs.initials < rhs.initials
    }
    
    static func == (lhs: Teacher, rhs: Teacher) -> Bool {
        lhs.initials.caseInsensitiveCompare(rhs.initials) == .orderedSame &&
        lhs.email.caseInsensitiveCompare(rhs.email) == .orderedSame
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(initials.lowercased())
        hasher.combine(email.lowercased())
    }
    
    let initials: String
    let faculties: [Faculty]
    let email: String
    
    var departments: [Department] {
        Department.allCases.filter { department in
            !Set(department.faculties).isDisjoint(with: Set(faculties))
        }
    }
    
    static let dummy: Teacher = Teacher(initials: "unknown", faculties: [.computerScience], email: "unknownEmail")
}

enum Lesson: String, CaseIterable, Hashable, Comparable, Codable {
    static func < (lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.comparisonValue < rhs.comparisonValue
    }
    
    case Monday1st, Monday2nd, Monday3rd, Monday4th, Monday5th, Monday6th, Monday7th,Tuesday1st,Tuesday2nd,Tuesday3rd,Tuesday4th,Tuesday5th,Wednesday1st, Wednesday2nd, Wednesday3rd, Wednesday4th, Wednesday5th, Wednesday6th, Wednesday7th,Thursday1st,Thursday2nd,Thursday3rd,Thursday4th,Thursday5th,Friday1st, Friday2nd, Friday3rd, Friday4th, Friday5th, Friday6th, Friday7th,Saturday1st,Saturday2nd,Saturday3rd,Saturday4th
    
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
      case .Monday6th:
        return 6
      case .Monday7th:
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
      case .Wednesday6th:
        return 18
      case .Wednesday7th:
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
      case .Friday6th:
        return 30
      case .Friday7th:
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
    
    var canBeGivenReader: Bool {
        if self.rawValue.contains("1st") || self.rawValue.contains("6th") || self.rawValue.contains("7th") {
            return false
        } else {
            return true
        }
    }
}

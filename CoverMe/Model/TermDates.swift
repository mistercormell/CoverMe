//
//  SchoolCalendar.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 28/04/2023.
//

import Foundation

struct TermDates {
    var startDates: [TermDate] = []
    
    func getTimetableTiming(at date: Date) -> TimetableTiming {
        for i in 0..<startDates.count {
            let startDateOfTerm = startDates[i]
            if date <= startDateOfTerm.date {
                if startDates[i-1].term == Term.Summer {
                    return .Summer
                } else if startDates[i-1].term == Term.Michaelmas {
                    if let weeksDifference = Calendar.current.dateComponents([.weekOfYear], from: startDates[i-1].date, to: date).weekOfYear {
                        if weeksDifference <= 6 {
                            return .EarlyMichaelmas
                        }
                    }
                }
                return .Normal
            }
        }
        return .Normal
    }
    
    func getTermDate(for date: Date) -> TermDate? {
        for i in 0..<startDates.count {
            let startDateOfTerm = startDates[i]
            if (date < startDateOfTerm.date && i == 0) || (i == startDates.count - 1 && date >= startDateOfTerm.date) {
                return startDates[i]
            } else if date < startDateOfTerm.date  {
                return startDates[i-1]
            }
        }
        print("Couldn't calculate a term date for date: \(date.description), returning nil")
        return nil
    }
    
    func getTermDisplay(for date: Date) -> String {
        if let termDate = getTermDate(for: date) {
            return termDate.term.displayInitial + date.twoDigitYear
        } else {
            print("Couldn't calculate a term display for date: \(date.description), returning empty string")
            return ""
        }
    }
    
    func getPast3TermDisplays(for date: Date) -> [String] {
        var past3Terms: [TermDate] = []
        if let currentTerm = getTermDate(for: date) {
            past3Terms.append(currentTerm)
            if let index = startDates.firstIndex(where: { $0.date == currentTerm.date }) {
                if index >= 2 {
                    past3Terms.append(startDates[index-1])
                    past3Terms.append(startDates[index-2])
                    return past3Terms.map({
                        getTermDisplay(for: $0.date)
                    })
                }
            }

        }
        print("Was not able to find past 3 terms, fatal error")
        return []
    }
}

struct TermDate {
    let term: Term
    let date: Date
}

enum TimetableTiming: Codable {
   case EarlyMichaelmas, Normal, Summer
}

enum Term: String {
    case Michaelmas, Lent, Summer
    
    var displayInitial: String {
        return String(self.rawValue.prefix(1))
    }
}

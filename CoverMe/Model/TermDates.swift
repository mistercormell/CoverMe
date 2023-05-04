//
//  SchoolCalendar.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 28/04/2023.
//

import Foundation

struct TermDates {
    var startDates: [TermDate] = []
    var isSummer: Bool {
        self.isSummer(at: Date.now)
    }
    
    func isSummer(at date: Date) -> Bool {
        for i in 0..<startDates.count {
            let startDateOfTerm = startDates[i]
            if date <= startDateOfTerm.date {
                return startDates[i-1].term == Term.Summer
            }
        }
        return false
    }
    
    func getTermDisplay(for date: Date) -> String {
        for i in 0..<startDates.count {
            let startDateOfTerm = startDates[i]
            if (date < startDateOfTerm.date && i == 0) || (i == startDates.count - 1 && date >= startDateOfTerm.date) {
                return startDates[i].term.displayInitial + date.twoDigitYear
            } else if date < startDateOfTerm.date  {
                return startDates[i-1].term.displayInitial + date.twoDigitYear
            }
        }
        print("Couldn't calculate a term display for date: \(date.description), returning empty string")
        return ""
    }
}

struct TermDate {
    let term: Term
    let date: Date
}

enum Term: String {
    case Michaelmas, Lent, Summer
    
    var displayInitial: String {
        return String(self.rawValue.prefix(1))
    }
}

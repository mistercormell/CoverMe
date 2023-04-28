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
        let now = Date.now
        for startDateOfTerm in startDates {
            if now >= startDateOfTerm.date {
                return startDateOfTerm.term == Term.Summer
            }
        }
        return false
    }
}

struct TermDate {
    let term: Term
    let date: Date
}

enum Term: String {
    case Michaelmas, Lent, Summer
}

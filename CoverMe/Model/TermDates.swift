//
//  SchoolCalendar.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 28/04/2023.
//

import Foundation

struct TermDates {
    var startDates: [TermDate] = []
    
    func isSummer(at date: Date) -> Bool {
        for i in 0..<startDates.count {
            let startDateOfTerm = startDates[i]
            if date <= startDateOfTerm.date {
                return startDates[i-1].term == Term.Summer
            }
        }
        return false
    }
    
    var isSummer: Bool {
        self.isSummer(at: Date.now)
    }
}

struct TermDate {
    let term: Term
    let date: Date
}

enum Term: String {
    case Michaelmas, Lent, Summer
}

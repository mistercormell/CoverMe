//
//  SchoolCalendar.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 28/04/2023.
//

import Foundation

struct TermDates {
    let startDates: [TermDate] = []
}

struct TermDate {
    let term: Term
    let date: Date
}

enum Term {
    case Michaelmas, Lent, Summer
}

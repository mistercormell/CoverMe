//
//  Date.swift
//  CoverMe
//
//  Created by David Cormell on 09/03/2023.
//

import Foundation

extension Date {
    var day: String {
        let weekDays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        let dayOfWeek = components.weekday ?? 1
        
        return weekDays[dayOfWeek - 1]
    }
}

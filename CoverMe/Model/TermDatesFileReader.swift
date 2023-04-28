//
//  TermDatesFileReader.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 28/04/2023.
//

import Foundation

class TermDatesFileReader {
    static func createTermStartDateFrom(line: String) -> TermDate? {
        let parts = line.components(separatedBy: ",")
        if let term = Term(rawValue: parts[1]) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-mm-y"
            if let date = formatter.date(from: parts[0]) {
                let termDate = TermDate(term: term, date: date)
                return termDate
            } else {
                print("Invalid term date")
            }
        } else {
            print("Invalid term name: parts[1]")
        }
        return nil
    }
    
    static func createTermDatesFromFile(filename: String) -> TermDates {
        if let filepath = Bundle.main.path(forResource: filename, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let trimmedContent = contents.trimmingCharacters(in: .whitespacesAndNewlines)
                let lines = trimmedContent.components(separatedBy: "\n")
                var startDates: [TermDate] = []
                for line in lines {
                    if let termDate = createTermStartDateFrom(line: line) {
                        startDates.append(termDate)
                    } else {
                        print("Error, could not extract valid timetabled lesson from: \(line)")
                    }
                }
                return TermDates(startDates: startDates)
            } catch {
                print("Couldn't load contents of file")
            }
        } else {
            print("File not found!")
        }
        
        return TermDates()
    }
}

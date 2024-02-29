//
//  CSVGenerator.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 29/02/2024.
//

import Foundation

class CSVGenerator {
    func generateCSV(confirmedCover: [CoverArrangementWithDate]) -> URL {
            var fileURL: URL!
            // heading of CSV file.
            let heading = "Date, Master, Reason, Covered By, Cover Description\n"
            
            // file rows
        let rows = confirmedCover.map { "\($0.startOfDayDate),\($0.coverArrangement.originalTeacher.initials),\($0.coverArrangement.reasonForCover?.rawValue ?? "" ),\($0.coverArrangement.isReadingSchool ? "Reader" : $0.coverArrangement.coverTeacher.initials),\($0.display)" }
            
            // rows to string data
            let stringData = heading + rows.joined(separator: "\n")
            
            do {
                
                let path = try FileManager.default.url(for: .documentDirectory,
                                                       in: .allDomainsMask,
                                                       appropriateFor: nil,
                                                       create: false)
                
                fileURL = path.appendingPathComponent("CoverReportGenerated\(Date.now.description).csv")
                
                // append string data to file
                try stringData.write(to: fileURL, atomically: true , encoding: .utf8)
                print(fileURL!)
                
            } catch {
                print("error generating csv file")
            }
            return fileURL
        }
}

//
//  CSVGenerator.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 29/02/2024.
//

import Foundation

struct TeacherStats {
    var coversRequired: Int = 0
    var coversProvided: Int = 0
    var reasonCounts: [ReasonForCover?: Int] = [:]
    
    var mostCommonReason: String {
        reasonCounts
            .max(by: { $0.value < $1.value })?
            .key?.rawValue ?? "N/A"
    }
}

class CSVGenerator {
    func generateCSV(confirmedCover: [CoverArrangementWithDate], start: Date, end: Date) -> URL {
        let filteredCover = confirmedCover.filter({
            $0.date >= start && $0.date <= end
        })
        
        return generateCSV(confirmedCover: filteredCover)
    }
    
    func generateCSV(confirmedCover: [CoverArrangementWithDate]) -> URL {
        var fileURL: URL!
        // heading of CSV file.
        let heading = "Date, Master, Reason, Covered By, Cover Description\n"
            
            // file rows
        let rows = confirmedCover.map { "\($0.date.shortDateDescription),\($0.coverArrangement.originalTeacher.initials),\($0.coverArrangement.reasonForCover?.rawValue ?? "" ),\($0.coverArrangement.isReadingSchool ? "Reader" : $0.coverArrangement.coverTeacher.initials),\($0.display)" }
        
        
        let stats = generateTeacherStats(from: confirmedCover)
        
        let statsHeading = "\n\nTeacher (initials),Number of Covers Required,Number of Covers Provided,Most Common Reason\n"
        let statsRows = stats.keys.sorted().map { initials in
                let teacherStats = stats[initials]!
                return "\(initials),\(teacherStats.coversRequired),\(teacherStats.coversProvided),\(teacherStats.mostCommonReason)"
            }
            
            // rows to string data
        let stringData = heading +
            rows.joined(separator: "\n") + "\n\n" +
            statsHeading +
            statsRows.joined(separator: "\n")
            
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
    
    private func generateTeacherStats(from arrangements: [CoverArrangementWithDate]) -> [String: TeacherStats] {
        var stats: [String: TeacherStats] = [:]
        
        for arrangement in arrangements {
            let coverArrangement = arrangement.coverArrangement
            
            // Update original teacher stats (covers required)
            let originalTeacherInitials = coverArrangement.originalTeacher.initials
            stats[originalTeacherInitials] = stats[originalTeacherInitials] ?? TeacherStats()
            stats[originalTeacherInitials]?.coversRequired += 1
            
            // Update reason counts for original teacher
            let reason = coverArrangement.reasonForCover
            stats[originalTeacherInitials]?.reasonCounts[reason, default: 0] += 1
            
            // Update cover teacher stats (covers provided) - only if not a reading school cover
            if !coverArrangement.isReadingSchool {
                let coverTeacherInitials = coverArrangement.coverTeacher.initials
                stats[coverTeacherInitials] = stats[coverTeacherInitials] ?? TeacherStats()
                stats[coverTeacherInitials]?.coversProvided += 1
            }
        }
        
        return stats
    }
}

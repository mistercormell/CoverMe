//
//  TimetableDataStore.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 01/10/2025.
//

import Foundation
import ParseSwift

class TimetableDataStore {
    static let shared = TimetableDataStore()
    private init() {}

    var timetableUrl: URL?
    var termDatesUrl: URL?
    var staffingUrl: URL?
    
    func initialize(objectId: String) async {
        do {
            try await syncTimetableData(objectId: objectId)
            print("Sync complete. Local files ready")
        } catch {
            print("Failed to sync timetable: \(error)")
        }
    }
    
    func saveDataLocally(data: Data, filename: String) throws -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docs.appendingPathComponent(filename)
        try data.write(to: fileURL)
        return fileURL
    }
    
    func saveCacheMetadata(_ metadata: LocalTimetableCacheMetadata) {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docs.appendingPathComponent("\(metadata.objectId).json")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(metadata) {
            try? encoded.write(to: url)
        }
    }

    func loadCacheMetadata(for objectId: String) -> LocalTimetableCacheMetadata? {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docs.appendingPathComponent("\(objectId).json")
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(LocalTimetableCacheMetadata.self, from: data)
    }
    
    fileprivate func getFileDataAndSaveUrl(_ parseFile: ParseFile?) async throws -> URL? {
        guard let file = parseFile else { return nil }
        
        let fileContent = try await file.fetch()
        
        if let data = fileContent.data {
            let url = try saveDataLocally(data: data, filename: fileContent.name)
            return url
        } else if let fileURL = fileContent.url {
            let (data, _) = try await URLSession.shared.data(from: fileURL)
            let url = try saveDataLocally(data: data, filename: fileContent.name)
            return url
        } else {
            print("Warning: ParseFile '\(fileContent.name)' has no data or URL")
            return nil
        }
    }
    
    func syncTimetableData(objectId: String) async throws {
        // Load cached metadata (if any)
        let metadata = loadCacheMetadata(for: objectId)
        // Fetch latest from Parse
        let record = try await TimetableData.query("objectId" == objectId).first()
        
        if let updatedAt = record.updatedAt {
            
            // Compare dates
            if let cached = metadata, cached.lastUpdated >= updatedAt {
                print("Local cache is up-to-date.")
                staffingUrl = cached.localFileURLs[0]
                termDatesUrl = cached.localFileURLs[1]
                timetableUrl = cached.localFileURLs[2]
                return
            }
            
            // Download files
            
            staffingUrl = try await getFileDataAndSaveUrl(record.staffing)
            termDatesUrl = try await getFileDataAndSaveUrl(record.termdates)
            timetableUrl = try await getFileDataAndSaveUrl(record.timetable)
            
            // Save metadata if files downloaded successfully
            guard let staffingUrl = staffingUrl, let termDatesUrl = termDatesUrl, let timetableUrl = timetableUrl else {
                print("Failed to download all required files.")
                return
            }
            
            let newMetadata = LocalTimetableCacheMetadata(objectId: objectId, lastUpdated: updatedAt, localFileURLs: [staffingUrl, termDatesUrl, timetableUrl].compactMap { $0 })
            saveCacheMetadata(newMetadata)
            
        } else {
            print("No connection to Parse. Attempting to Load local cache")
            if let cached = metadata {
                staffingUrl = cached.localFileURLs[0]
                termDatesUrl = cached.localFileURLs[1]
                timetableUrl = cached.localFileURLs[2]
            } else {
                print("No cache and no connection to Parse")
            }
        }
    }
    
}

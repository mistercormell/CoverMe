//
//  LocalTimetableCacheMetadata.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 01/10/2025.
//

import Foundation

struct LocalTimetableCacheMetadata: Codable {
    var objectId: String
    var lastUpdated: Date
    var localFileURLs: [URL]
}

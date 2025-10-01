//
//  TimetableDataDao.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 01/10/2025.
//

import Foundation
import ParseSwift

struct TimetableData: ParseObject {
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
    
    
    var timetable: ParseFile?
    var staffing: ParseFile?
    var termdates: ParseFile?
}

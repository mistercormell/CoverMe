//
//  DepartmentCoverDao.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 12/05/2023.
//

import Foundation
import ParseSwift

struct DepartmentCoverDao: ParseObject {
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
    
    
    var departmentName: String?
    var json: String?
}

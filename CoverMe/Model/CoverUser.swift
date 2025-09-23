//
//  CoverUser.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 23/09/2025.
//
import ParseSwift
import Foundation

struct CoverUser: ParseUser {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    //: These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
    
    //customProperty
    var department: Department?
}

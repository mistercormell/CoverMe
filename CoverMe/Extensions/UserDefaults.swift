//
//  UserDefaults.swift
//  CoverMe
//
//  Created by David Cormell on 04/05/2023.
//

import Foundation

extension UserDefaults {
    var isSetupComplete: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "isSetupComplete") as? Bool) ?? false
        } set {
            UserDefaults.standard.setValue(newValue, forKey: "isSetupComplete")
        }
    }
    
    var selectedDepartment: Department? {
        get {
            if let departmentString = UserDefaults.standard.value(forKey: "selectedDepartment") as? String {
                return Department(rawValue: departmentString)
            }
            return nil
        } set {
            UserDefaults.standard.setValue(newValue?.rawValue, forKey: "selectedDepartment")
        }
    }
}

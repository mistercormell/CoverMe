//
//  SetupViewModel.swift
//  CoverMe
//
//  Created by David Cormell on 04/05/2023.
//

import Foundation

class SetupViewModel: ObservableObject {
    @Published var selectedDepartment: Department? {
        didSet {
            UserDefaults.standard.selectedDepartment = selectedDepartment
        }
    }
    
    init() {
        self.selectedDepartment = UserDefaults.standard.selectedDepartment
    }
}

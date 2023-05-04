//
//  SettingsView.swift
//  CoverMe
//
//  Created by David Cormell on 04/05/2023.
//

import SwiftUI

struct CoverSetupView: View {
    @ObservedObject var viewModel: CoverPickerViewModel
    @State private var selectedDepartment: Department = .ComputerScience
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("CoverMe - Initial Setup")) {
                    Picker(selection: $selectedDepartment, label: Text("Department"), content: {
                        ForEach(Department.allCases, id: \.self) {
                            Text($0.display)
                        }
                    })
                }
            }
            Button {
                UserDefaults.standard.selectedDepartment = selectedDepartment
                viewModel.selectedDepartment = selectedDepartment
            } label: {
                Text("Confirm")
                    .font(.title2)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CoverSetupView(viewModel: CoverPickerViewModel())
    }
}

//
//  SettingsView.swift
//  CoverMe
//
//  Created by David Cormell on 04/05/2023.
//

import SwiftUI

struct CoverSetupView: View {
    @State private var selectedDepartment: Department = .computerScience
    @ObservedObject var viewModel: SetupViewModel
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("CoverMe - Initial Setup")) {
                    Picker(selection: $selectedDepartment, label: Text("Department"), content: {
                        ForEach(Department.allCases, id: \.self) {
                            Text($0.displayName)
                        }
                    })
                }
            }
            Button {
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
        CoverSetupView(viewModel: SetupViewModel())
    }
}

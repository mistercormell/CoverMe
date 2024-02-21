//
//  AddCustomCoverView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 20/02/2024.
//

import SwiftUI

//- school / div selection

struct AddCustomCoverView: View {
    @ObservedObject var viewModel: CoverPickerViewModel
    
    @State var teacherInitialsToCover: String
    @State var coverTeacherInitials: String
    @State private var selectedReason: ReasonForCover = .health
    @State private var selectedDate: Date = Date.now
    @State private var selectedSchool: Lesson?
    @State private var notes: String = ""
    
    @Binding var isShowing: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Picker(selection: $teacherInitialsToCover, label: Text("Teacher"), content: {
                    ForEach(viewModel.getTeamInitials(), id: \.self) {
                        Text($0)
                    }
                })
                Picker(selection: $viewModel.selectedReason,
                       label: Text("Reason"), content: {
                    ForEach(ReasonForCover.allCases, id: \.self) { reason in
                        HStack {
                            Text(reason.rawValue)
                            Image(systemName: reason.iconName)
                        }.tag(reason)
                    }
                })
                DatePicker(selection: $selectedDate, displayedComponents: .date) {
                    Text("Date of Cover")
                }
                Picker(selection: $selectedSchool, label: Text("School"), content: {
                    Text(" ").tag(nil as Lesson?)
                    ForEach(viewModel.getLessonsTaught(on: selectedDate, by: teacherInitialsToCover), id: \.self) {
                        Text($0.displayName).tag($0 as Lesson?)
                    }
                })
                Picker(selection: $coverTeacherInitials, label: Text("Cover Teacher"), content: {
                    ForEach(viewModel.getTeamInitials(), id: \.self) {
                        Text($0)
                    }
                })
                TextField("Notes", text: $notes)
                Section {
                    Button("Add to Pending", action: {
                        if let selectedSchool = selectedSchool {
                            viewModel.addCustomCoverArrangement(reason: selectedReason, teacherToCover: teacherInitialsToCover, coverTeacher: coverTeacherInitials, selectedDate: selectedDate, lesson: selectedSchool, notes: notes)
                            isShowing = false
                        } else {
                            print("Wasn't able to find any lessons that the person taught, failing to add")
                        }
                        
                    })
                }
            }
        }
    }
}

#Preview {
    AddCustomCoverView(viewModel: CoverPickerViewModel(selectedDepartment: .ComputerScience), teacherInitialsToCover: "DPC", coverTeacherInitials: "DPC", isShowing: .constant(true))
}

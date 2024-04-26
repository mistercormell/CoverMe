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
    @State var possibleSchools: [Lesson]
    
    @Binding var isShowing: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Picker(selection: $teacherInitialsToCover, label: Text("Teacher"), content: {
                    ForEach(viewModel.getTeamInitials(), id: \.self) {
                        Text($0)
                    }
                })
                Picker(selection: $selectedReason,
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
                if selectedSchool == nil {
                    Text("No lessons for this member of staff on this day")
                } else {
                    Picker(selection: $selectedSchool, label: Text("School"), content: {
                        ForEach(possibleSchools, id: \.self) {
                            Text($0.displayName).tag($0 as Lesson?)
                        }
                    })
                }
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
            .onChange(of: teacherInitialsToCover) { newTeacher in
                possibleSchools = viewModel.getLessonsTaught(on: selectedDate, by: newTeacher)
                selectedSchool = possibleSchools.first
            }
            .onChange(of: selectedDate) { newDate in
                possibleSchools = viewModel.getLessonsTaught(on: newDate, by: teacherInitialsToCover)
                selectedSchool = possibleSchools.first
            }
            .onAppear(perform: {
                if selectedSchool == nil {
                    if let firstSchool = viewModel.getLessonsTaught(on: selectedDate, by: teacherInitialsToCover).first {
                        selectedSchool = firstSchool
                    }
                }
            })
        }
    }
}

#Preview {
    AddCustomCoverView(viewModel: CoverPickerViewModel(selectedDepartment: .ComputerScience), teacherInitialsToCover: "DPC", coverTeacherInitials: "DPC", possibleSchools: [.Friday1st,.Friday2nd], isShowing: .constant(true))
}

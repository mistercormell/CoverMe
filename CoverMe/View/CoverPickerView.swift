//
//  ContentView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import SwiftUI

struct CoverPickerView: View {
    @StateObject var viewModel = CoverPickerViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("What needs covering")) {
                    Picker(selection: $viewModel.selectedTeacherInitials, label: Text("Teacher"), content: {
                        ForEach(viewModel.getTeamInitials(), id: \.self) {
                            Text($0)
                        }
                    })
                    DatePicker(selection: $viewModel.selectedDate, in: Date.now..., displayedComponents: .date) {
                        Text("Date of Cover")
                    }
                    Picker(selection: $viewModel.selectedLesson, label: Text("Lesson"), content: {
                        ForEach(viewModel.getLessonsTaughtOnDate(), id: \.self) {
                            Text($0.displayName)
                        }
                    })
                }
                Button("Find Cover", action: {
                    viewModel.updateAvailableCover()
                })
                Section(header: Text("\(viewModel.availableCover.first?.toBeCoveredDisplay ?? "")")) {
                    if viewModel.availableCover.count <= 0 {
                        Text("No cover options available")
                    } else {
                        
                        List {
                            ForEach(viewModel.availableCover) { cover in
                                NavigationLink(cover.coverOptionDisplay) {
                                    SelectedCoverView(coverDetail: cover.display, date: viewModel.selectedDate, email: cover.coverTeacher.getEmail())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CoverPickerView()
    }
}

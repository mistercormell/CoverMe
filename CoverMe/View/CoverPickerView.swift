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
                }
                Button("Find Cover", action: {
                    viewModel.updateAvailableCoverAllDay()
                })
                ForEach(Array(viewModel.availableCoverAllDay.keys).sorted(), id: \.self) { lesson in
                    Section(header: Text("\(viewModel.getLessonDisplay(lesson: lesson))")) {
                        List {
                            if let availableCover = viewModel.availableCoverAllDay[lesson] {
                                ForEach(availableCover) { cover in
                                    NavigationLink(cover.coverOptionDisplay) {
                                        SelectedCoverView(coverDetail: cover.display, date: viewModel.selectedDate, email: cover.coverTeacher.getEmail())
                                    }
                                }
                            } else {
                                Text("No cover options available")
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

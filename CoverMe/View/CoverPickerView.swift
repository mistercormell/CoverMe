//
//  ContentView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import SwiftUI

struct CoverPickerView: View {
    @ObservedObject var viewModel: CoverPickerViewModel
    @State private var showConfirmation = false

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
                                    Button(cover.coverOptionDisplay) {
                                        showConfirmation = true
                                    }
                                    .buttonStyle(.plain)
                                    .actionSheet(isPresented: $showConfirmation) {
                                        ActionSheet(
                                            title: Text("\(cover.coverOptionDisplay)"),
                                            buttons: [
                                                .default(Text("Add to proposed cover")) {
                                                    viewModel.addCoverArrangementWithDate(cover: cover)
                                                },
                                                .destructive(Text("Cancel")) {
                                                    print("Cancelled")
                                                }

                                            ]
                                        )
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
        CoverPickerView(viewModel: CoverPickerViewModel())
    }
}

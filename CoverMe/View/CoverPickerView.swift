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
    @State private var selectedCover: CoverArrangement?

    var body: some View {
        Form {
                Section(header: Text("What needs covering for: \(viewModel.selectedDepartment.display)")) {
                    Picker(selection: $viewModel.selectedTeacherInitials, label: Text("Teacher"), content: {
                        ForEach(viewModel.getTeamInitials(), id: \.self) {
                            Text($0)
                        }
                    })
                    DatePicker(selection: $viewModel.selectedDate, displayedComponents: .date) {
                        Text("Date of Cover")
                    }
                }
                HStack {
                    Button("Find Cover", action: {
                        viewModel.updateAvailableCoverAllDay()
                    })
                    Spacer()
                    Divider()
                    Spacer()
                    Button("Auto Generate Cover", action: {
                        viewModel.addAutogeneratedCover()
                    })
                }
                .buttonStyle(BorderlessButtonStyle())
                ForEach(Array(viewModel.availableCoverAllDay.keys).sorted(), id: \.self) { lesson in
                    Section(header: Text("\(viewModel.getLessonDisplay(lesson: lesson))")) {
                        List {
                            if let availableCover = viewModel.availableCoverAllDay[lesson] {
                                ForEach(availableCover) { cover in
                                    Button {
                                        showConfirmation = true
                                        selectedCover = cover
                                    } label: {
                                        HStack {
                                            Text(cover.coverOptionDisplay)
                                            Spacer()
                                            if viewModel.getTallyDisplay(for: cover) > 0 {
                                                Image(systemName: "\(viewModel.getTallyDisplay(for: cover)).circle")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .actionSheet(isPresented: $showConfirmation) {
                                        ActionSheet(
                                            title: Text("\(selectedCover?.coverOptionDisplay ?? "No cover")"),
                                            buttons: [
                                                .default(Text("Add to proposed cover")) {
                                                    if let cover = selectedCover {
                                                        viewModel.addCoverArrangementWithDate(cover: cover)
                                                    }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CoverPickerView(viewModel: CoverPickerViewModel(selectedDepartment: .ComputerScience))
    }
}

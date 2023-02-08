//
//  ContentView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import SwiftUI

struct CoverPickerView: View {
    @State var selectedTeacherInitials: String
    @StateObject var viewModel = CoverPickerViewModel()

    var body: some View {
        Form {
            Section(header: Text("What needs covering")) {
                Picker(selection: $selectedTeacherInitials, label: Text("Teacher"), content: {
                    ForEach(viewModel.getTeamInitials(), id: \.self) {
                        Text($0)
                    }
                })
                Picker(selection: $viewModel.selectedLesson, label: Text("Lesson"), content: {
                    ForEach(viewModel.getLessonsTaught(for: selectedTeacherInitials), id: \.self) {
                        Text($0.displayName)
                    }
                })
            }
            Button("Find Cover", action: {
                viewModel.updateAvailableCoverFor(Teacher(initials: selectedTeacherInitials), during: viewModel.selectedLesson)
            })
            Section(header: Text("\(viewModel.availableCover.first?.toBeCoveredDisplay ?? "")")) {
                if viewModel.availableCover.count <= 0 {
                    Text("No cover options available")
                } else {
                    
                    List {
                        ForEach(viewModel.availableCover) { cover in
                            HStack {
                                Text("\(cover.coverOptionDisplay)")
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
        CoverPickerView(selectedTeacherInitials: "DPC")
    }
}

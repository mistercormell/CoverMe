//
//  ContentView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTeacherInitials: String
    @State var selectedLesson: Lesson = Lesson.Monday1st
    @State var availableCover: [CoverArrangement] = []
    let timetable: Timetable
    let coverManager: CoverManager
    
    var body: some View {
        Form {
            Section(header: Text("What needs covering")) {
                Picker(selection: $selectedTeacherInitials, label: Text("Teacher"), content: {
                    ForEach(timetable.team, id: \.self.initials) {
                        Text($0.initials)
                    }
                })
                Picker(selection: $selectedLesson, label: Text("Lesson"), content: {
                    ForEach(Lesson.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                })
            }
            Button("Find Cover", action: {
                availableCover = coverManager.getCoverOptions(teacher: Teacher(initials: selectedTeacherInitials), lesson: selectedLesson)
            })
            Section {
                if availableCover.count <= 0 {
                    Text("No cover options available")
                } else {
                    List {
                        ForEach(availableCover) { cover in
                            HStack {
                                Text("\(cover.teacher.initials)")
                                Text("\(cover.room.rawValue)")
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
        ContentView(selectedTeacherInitials: "DPC", selectedLesson: Lesson.Monday1st, timetable: Timetable(timetabledLessons: Timetable.example), coverManager: CoverManager(timetable: Timetable(timetabledLessons: Timetable.example)))
    }
}

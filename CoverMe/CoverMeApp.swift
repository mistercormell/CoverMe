//
//  CoverMeApp.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import SwiftUI

@main
struct CoverMeApp: App {
    let timetable = TimetableFileReader.createTimetableFromFile(filename: "timetable")
    var body: some Scene {
        WindowGroup {
            CoverPickerView(selectedTeacherInitials: "DPC", selectedLesson: Lesson.Monday1st, timetable: timetable, coverManager: CoverManager(timetable: timetable))
        }
    }
}

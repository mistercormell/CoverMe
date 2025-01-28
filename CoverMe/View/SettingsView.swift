//
//  SettingsView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 12/09/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: ManageTeamView(), label: { Text("Manage Team") } )
                NavigationLink(destination: ManageTeamTimetableView(), label: { Text("Manage Timetable") } )
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

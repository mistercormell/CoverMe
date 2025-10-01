//
//  LaunchScreenView.swift
//  CoverMe
//
//  Created by David Cormell on 04/05/2023.
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject var viewModel: LoginViewModel = LoginViewModel()
    @State var areFilesReady = false
    
    var body: some View {
        VStack {
            if areFilesReady {
                if viewModel.isLoggedIn {
                    MainTabView(viewModel: CoverPickerViewModel(selectedDepartment: viewModel.currentUser?.department ?? .computerScience), authViewModel: viewModel)
                } else {
                    LoginView(vm: viewModel)
                }
            } else {
                ProgressView("Loading Timetable, Staffing and Term Dates Data...")
            }
        }
        .task {
            await TimetableDataStore.shared.initialize(objectId: "kwRnrwQGpu")
            areFilesReady = true
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

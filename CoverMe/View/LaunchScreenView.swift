//
//  LaunchScreenView.swift
//  CoverMe
//
//  Created by David Cormell on 04/05/2023.
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject var viewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        if viewModel.isLoggedIn {
            MainTabView(viewModel: CoverPickerViewModel(selectedDepartment: viewModel.currentUser?.department ?? .computerScience), authViewModel: viewModel)
        } else {
            LoginView(vm: viewModel)
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

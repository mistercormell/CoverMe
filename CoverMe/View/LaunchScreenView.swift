//
//  LaunchScreenView.swift
//  CoverMe
//
//  Created by David Cormell on 04/05/2023.
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject var viewModel: SetupViewModel = SetupViewModel()
    
    var body: some View {
        if let department = viewModel.selectedDepartment {
            MainTabView(viewModel: CoverPickerViewModel(selectedDepartment: department))
        } else {
            CoverSetupView(viewModel: viewModel)
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

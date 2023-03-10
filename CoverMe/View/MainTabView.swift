//
//  MainTabView.swift
//  CoverMe
//
//  Created by David Cormell on 09/03/2023.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = CoverPickerViewModel()
    
    var body: some View {
        TabView {
            CoverPickerView(viewModel: viewModel)
                .tabItem {
                    Label("Set", systemImage: "list.dash")
                }

            CurrentCoverView(viewModel: viewModel)
                .tabItem {
                    Label("Review", systemImage: "square.and.pencil")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

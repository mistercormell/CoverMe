//
//  MainTabView.swift
//  CoverMe
//
//  Created by David Cormell on 09/03/2023.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel: CoverPickerViewModel
    
    var body: some View {
        TabView {
            CoverPickerView(viewModel: viewModel)
                .tabItem {
                    Label("Set", systemImage: "list.dash")
                }

            DraftCoverView(viewModel: viewModel)
                .tabItem {
                    Label("Pending", systemImage: "square.and.pencil")
                }
                .badge(viewModel.coverRecord.filter({
                    $0.status == .draft
                }).count)
            ConfirmedCoverView(viewModel: viewModel)
                .tabItem {
                    Label("Confirmed", systemImage: "person.fill.checkmark")
                }
        }
        .onAppear(perform: {
            viewModel.restoreCoverRecord()
        })

    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(viewModel: CoverPickerViewModel(selectedDepartment: .ComputerScience))
    }
}

//
//  CoverMeApp.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 07/02/2023.
//

import SwiftUI
import ParseSwift

@main
struct CoverMeApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
        }
    }
    
    init() {
        ParseSwift.initialize(applicationId: "VqXwbxL4VLSrYW5laWKRPMYK2rWH80JAmvZQZogA", clientKey: "OjspuQcAHkJFAyrq3K4FZgQ732qqhMn5wEzM704H", serverURL: URL(string: "https://parseapi.back4app.com")!)

    }
}

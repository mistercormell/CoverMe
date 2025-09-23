//
//  LoginViewModel.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 23/09/2025.
//

import SwiftUI
import ParseSwift

class LoginViewModel: ObservableObject {
    private(set) var currentUser: CoverUser?
    @Published var isLoggedIn = false
    @Published var username = ""
    @Published var password = ""
    @Published var errorMessage: String?

    init() {
        currentUser = CoverUser.current
        checkCurrentUser()
    }

    /// Check if there's a cached user
    func checkCurrentUser() {
        if let user = CoverUser.current {
            print("Auto-login user:", user.username ?? "")
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }

    func login() {
        Task {
            do {
                let user = try await CoverUser.login(username: username, password: password)
                currentUser = user
                isLoggedIn = true
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func logout() {
        Task {
            do {
                try await CoverUser.logout()
                isLoggedIn = false
                username = ""
                password = ""
                currentUser = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}


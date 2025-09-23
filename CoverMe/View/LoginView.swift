//
//  LoginView.swift
//  CoverMe
//
//  Created by Cormell, David - DPC on 23/09/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: LoginViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image("AppIconImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(30)
            TextField("Username", text: $vm.username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            SecureField("Password", text: $vm.password)
                .textFieldStyle(.roundedBorder)

            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
    
            Button("Login") {
                vm.login()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.22, green: 0.71, blue: 1))
                }
                .padding()
    }
}

#Preview {
    LoginView(vm: LoginViewModel())
}

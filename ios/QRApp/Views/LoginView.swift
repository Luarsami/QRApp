//
//  LoginView.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @EnvironmentObject private var navigationManager: NavigationManager

    var body: some View {
        NavigationStack {  
            VStack {
                Text("Bienvenido")
                    .font(.largeTitle)
                    .padding()

                Button(action: { authViewModel.authenticate() }) {
                    HStack {
                        Text("Iniciar sesión con Face ID / Touch ID")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()

                if authViewModel.requiresPin {
                    VStack {
                        SecureField("Ingresa tu PIN", text: $authViewModel.pin)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        if !authViewModel.isPinCorrect {
                            Text("PIN incorrecto")
                                .foregroundColor(.red)
                        }

                        Button("Validar PIN") {
                            authViewModel.validatePIN()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
            .onAppear {
                if authViewModel.isAuthenticated {
                    DispatchQueue.main.async {
                        navigationManager.push(.home)
                    }
                }
            }
            .onChange(of: authViewModel.isAuthenticated) { _, newValue in
                DispatchQueue.main.async {
                    if newValue {
                        navigationManager.push(.home)
                    } else {
                        navigationManager.popToRoot()
                    }
                }
            }
        }
    }
}

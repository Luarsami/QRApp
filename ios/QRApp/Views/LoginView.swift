//
//  LoginView.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var pin = ""
    @State private var isPinCorrect = true
    @State private var storedPin: String? = nil

    var body: some View {
        VStack {
            Text("Bienvenido")
                .font(.largeTitle)
                .padding()

            Button(action: { authManager.authenticate() }) {
                HStack {
                    Image(systemName: "faceid")
                    Text("Iniciar sesión con Face ID / Touch ID")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()

            if authManager.requiresPin {
                VStack {
                    SecureField("Ingresa tu PIN", text: $pin)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    if !isPinCorrect {
                        Text("PIN incorrecto")
                            .foregroundColor(.red)
                    }

                    Button("Validar PIN") {
                        if storedPin == pin {
                            authManager.isAuthenticated = true
                        } else {
                            isPinCorrect = false
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .onAppear {
            // Intentar recuperar el PIN almacenado
            storedPin = KeychainHelper.getPIN()

            // Si no hay PIN guardado, establecer uno por defecto
            if storedPin == nil {
                let defaultPin = "1234"
                KeychainHelper.savePIN(defaultPin)
                storedPin = defaultPin
                print("PIN predeterminado guardado: \(defaultPin)")
            } else {
                print("PIN encontrado en Keychain: \(storedPin!)")
            }
        }
        .fullScreenCover(isPresented: $authManager.isAuthenticated) {
            ContentView()
        }
    }
}

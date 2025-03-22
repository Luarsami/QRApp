//
//  AuthenticationViewModel.swift
//  QRApp
//
//  Created by Luis Sarria on 22/03/25.
//

import SwiftUI
import LocalAuthentication

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var requiresPin = false
    @Published var pin = ""
    @Published var isPinCorrect = true
    @Published private var storedPin: String?

    init() {
        KeychainService.ensureDefaultPIN()
        storedPin = KeychainService.getPIN()
    }

    /// 🔹 Autenticación con Face ID / Touch ID
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Autenticarse para acceder a la app.") { success, _ in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        self.requiresPin = true
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.requiresPin = true
            }
        }
    }

    /// 🔑 Validar PIN ingresado por el usuario
    func validatePIN() {
        if storedPin == pin {
            isAuthenticated = true
        } else {
            isPinCorrect = false
        }
    }

    /// 🚪 Cerrar sesión correctamente
    func logout() {
        print("📌 Cerrando sesión...")
        DispatchQueue.main.async {
            self.isAuthenticated = false  // ✅ Bloquea la autenticación y vuelve al Login
            self.requiresPin = false
            self.pin = ""
            self.isPinCorrect = true
            
            NotificationCenter.default.post(name: .logoutNotification, object: nil)
        }
    }
}

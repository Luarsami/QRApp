//
//  AuthenticationManager.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import LocalAuthentication
import SwiftUI

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var requiresPin = false

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // Verifica si el dispositivo soporta Face ID / Touch ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Autenticarse para acceder a la app."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        print("🔴 Error en autenticación biométrica: \(authenticationError?.localizedDescription ?? "Desconocido")")
                        self.requiresPin = true
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                print("⚠️ Face ID / Touch ID no disponible. Usando PIN.")
                self.requiresPin = true
            }
        }
    }
}

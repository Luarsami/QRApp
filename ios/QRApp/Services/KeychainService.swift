//
//  KeychainHelper.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import Security
import Foundation

class KeychainService {
    private static let service = "com.seek.qrapp"
    private static let account = "userPIN"

    /// 💾 Guarda un PIN en Keychain de manera segura
    static func savePIN(_ pin: String) {
        guard let data = pin.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        // Eliminar cualquier PIN previo antes de guardar uno nuevo
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            print("❌ Error al guardar PIN en Keychain: \(status)")
        }
    }

    /// 🔓 Obtiene el PIN almacenado en Keychain
    static func getPIN() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let retrievedData = dataTypeRef as? Data {
            return String(data: retrievedData, encoding: .utf8)
        } else {
            print("⚠️ No se encontró ningún PIN en Keychain.")
            return nil
        }
    }

    /// 📌 Guarda un PIN por defecto si no hay uno almacenado
    static func ensureDefaultPIN() {
        if getPIN() == nil {
            let defaultPin = "1234"
            savePIN(defaultPin)
            print("🔐 PIN predeterminado guardado: \(defaultPin)")
        } else {
            print("🔐 PIN ya existente en Keychain.")
        }
    }
}

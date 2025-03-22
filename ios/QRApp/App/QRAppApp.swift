//
//  QRAppApp.swift
//  QRApp
//

import SwiftUI
import Flutter

@main
struct QRApp: App {
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var scannerViewModel = QRScannerViewModel(context: PersistenceController.shared.container.viewContext)
    @StateObject private var authViewModel = AuthenticationViewModel()

    init() {
        _ = FlutterManager.shared
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {  // ✅ Se mantiene NavigationView para compatibilidad con iOS <16
                RootView()
                    .environmentObject(navigationManager)
                    .environmentObject(scannerViewModel)
                    .environmentObject(authViewModel)
            }
            .navigationViewStyle(StackNavigationViewStyle())  // ✅ Estilo recomendado para evitar errores en iOS 16+
        }
    }
}

/// 🔹 Maneja la pantalla inicial basada en la autenticación
struct RootView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel

    var body: some View {
        if authViewModel.isAuthenticated {
            ContentView()
        } else {
            LoginView()
        }
    }
}

extension Notification.Name {
    static let logoutNotification = Notification.Name("logoutNotification")
}

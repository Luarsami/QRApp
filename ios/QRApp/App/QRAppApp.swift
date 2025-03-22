//
//  QRAppApp.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import SwiftUI
import Flutter

@main
struct QRApp: App {
    init() {
        _ = FlutterManager.shared
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

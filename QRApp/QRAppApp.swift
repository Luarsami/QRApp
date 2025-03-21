//
//  QRAppApp.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import SwiftUI

@main
struct QRAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

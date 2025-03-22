//
//  NavigationManager.swift
//  QRApp
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path: [AppRoutes] = []

    /// 🔹 Navegar a una nueva vista
    func push(_ view: AppRoutes) {
        path.append(view)
    }

    /// 🔙 Volver a la vista anterior
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    /// 🏠 Volver al inicio (Login)
    func popToRoot() {
        path.removeAll()
    }
}

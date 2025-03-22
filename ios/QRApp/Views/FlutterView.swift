//
//  FlutterView.swift
//  QRApp
//
//  Created by Luis Sarria on 21/03/25.
//

import SwiftUI
import Flutter

struct FlutterView: UIViewControllerRepresentable {
    @EnvironmentObject var scannerViewModel: QRScannerViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    func makeUIViewController(context: Context) -> FlutterViewController {
        let flutterEngine = FlutterManager.shared.flutterEngine
        flutterEngine.viewController = nil

        let controller = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        controller.view.isAccessibilityElement = false
        controller.view.accessibilityElementsHidden = true
        controller.view.shouldGroupAccessibilityChildren = true
        controller.view.accessibilityViewIsModal = true
        
        controller.view.subviews.forEach { subview in
            subview.isAccessibilityElement = false
            subview.accessibilityElementsHidden = true
        }

        let channel = FlutterMethodChannel(name: "seek.qrapp/channel", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "getScannedData":
                let qrCode = self.scannerViewModel.scannedCode ?? "No hay QR escaneado"
                result(["message": "Ejemplo de QR desde iOS 🚀", "scannedData": qrCode])

            case "logout":
                DispatchQueue.main.async {
                    print("📌 Flutter solicitó cierre de sesión")
                    self.authViewModel.logout()
                }
                result("Logout exitoso desde iOS 🚪")

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {}
}

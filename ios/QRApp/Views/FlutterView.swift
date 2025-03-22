//
//  FlutterView.swift
//  QRApp
//
//  Created by Luis Sarria on 21/03/25.
//

import SwiftUI
import Flutter

struct FlutterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FlutterViewController {
        let controller = FlutterViewController(engine: FlutterManager.shared.flutterEngine, nibName: nil, bundle: nil)
        let channel = FlutterMethodChannel(name: "seek.qrapp/channel", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { (call, result) in
            if call.method == "getScannedData" {
                result("Ejemplo de QR desde iOS")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        return controller
    }

    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {}
}

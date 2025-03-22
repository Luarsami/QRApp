//
//  QRScannerView.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import SwiftUI
import AVFoundation

struct QRScannerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: QRScannerViewModel
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: viewModel)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        // 🔹 Esperar a que la verificación de permisos termine antes de continuar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if !viewModel.cameraAccessGranted {
                print("🚨 Cámara no disponible, mostrando mensaje.")
                DispatchQueue.main.async {
                    let label = UILabel()
                    label.text = "No se ha concedido acceso a la cámara."
                    label.textAlignment = .center
                    label.frame = viewController.view.bounds
                    viewController.view.addSubview(label)
                }
                
                // 🔹 Simular el escaneo después de mostrar el mensaje
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewModel.simulateScan()
                }
            }
        }
        
        if let session = viewModel.setupCaptureSession() {
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = viewController.view.layer.bounds
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            viewController.view.layer.addSublayer(previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var viewModel: QRScannerViewModel
        
        init(viewModel: QRScannerViewModel) {
            self.viewModel = viewModel
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            viewModel.metadataOutput(output, didOutput: metadataObjects, from: connection)
        }
    }
}

//
//  QRScannerWrapperView.swift
//  QRApp
//

import SwiftUI

struct QRScannerWrapperView: View {
    @EnvironmentObject var viewModel: QRScannerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        QRScannerView(viewModel: viewModel)
            .onAppear {
                if !viewModel.isShowingScanner {
                    print("📌 Entrando al escáner, asegurando que isShowingScanner = true")
                    viewModel.isShowingScanner = true
                }
            }
            .onReceive(viewModel.$isShowingScanner) { isShowing in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if !isShowing && viewModel.captureSession?.isRunning == false {
                        print("✅ Cierre confirmado del escáner, navegando atrás")
                        dismiss()
                    } else {
                        print("⚠ Previniendo cierre inesperado del escáner")
                    }
                }
            }
        
    }
}

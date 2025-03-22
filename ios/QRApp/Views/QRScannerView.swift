//
//  QRScannerView.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import SwiftUI
import AVFoundation

struct QRScannerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRScannerView

        init(parent: QRScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               let scannedText = metadataObject.stringValue {
                DispatchQueue.main.async {
                    self.parent.scannedCode = scannedText
                    self.parent.isShowingScanner = false
                    self.parent.saveScannedCode()
                }
            }
        }
    }

    @Binding var isShowingScanner: Bool
    @Binding var scannedCode: String?

    let context = PersistenceController.shared.container.viewContext

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        // ⚠️ Verifica si la cámara tiene permisos antes de iniciar
        checkCameraPermission { granted in
            if granted {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.setupCamera(session: captureSession, viewController: viewController, context: context)
                }
            } else {
                DispatchQueue.main.async {
                    let label = UILabel()
                    label.text = "No se ha concedido acceso a la cámara."
                    label.textAlignment = .center
                    label.frame = viewController.view.bounds
                    viewController.view.addSubview(label)
                }
            }
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private func setupCamera(session: AVCaptureSession, viewController: UIViewController, context: Context) {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("⚠️ Cámara no disponible, simulando QR")
            DispatchQueue.main.async {
                self.scannedCode = "https://ejemplo.com" // Simulación de escaneo
                self.isShowingScanner = false
                self.saveScannedCode()
            }
            return
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            } else {
                print("⚠️ No se pudo agregar el input de la cámara.")
                return
            }
        } catch {
            print("⚠️ Error al acceder a la cámara: \(error.localizedDescription)")
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("⚠️ No se pudo agregar el output de metadatos.")
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        DispatchQueue.main.async {
            viewController.view.layer.addSublayer(previewLayer)
        }

        session.startRunning()
    }

    /// ✅ Verifica y solicita permiso para la cámara
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }

    func saveScannedCode() {
        let newCode = QRCode(context: context)
        newCode.id = UUID()
        newCode.content = scannedCode
        newCode.dateScanned = Date()

        do {
            try context.save()
        } catch {
            print("⚠️ Error guardando en CoreData: \(error.localizedDescription)")
        }
    }
}

//
//  QRScannerViewModel.swift
//  QRApp
//
//  Created by Luis Sarria on 22/03/25.
//

import Foundation
import AVFoundation
import CoreData
import Combine

class QRScannerViewModel: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    @Published var isShowingScanner = false
    @Published var cameraAccessGranted: Bool = false
    
    private let context: NSManagedObjectContext
    private let cameraPermissionService = CameraPermissionService()
    private var captureSession: AVCaptureSession?
    private var cancellables = Set<AnyCancellable>()
    private var isProcessingScan = false
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        cameraPermissionService.$isAuthorized
            .assign(to: \.cameraAccessGranted, on: self)
            .store(in: &cancellables)
        
        cameraPermissionService.checkPermission()

        print("📌 Iniciando QRScannerViewModel, isShowingScanner = true")
        self.isShowingScanner = true  
        NotificationCenter.default.addObserver(self, selector: #selector(resetScannerState), name: .logoutNotification, object: nil)
    }
    
    @objc private func resetScannerState() {
        print("🔄 Reset Scanner después del Logout")
        DispatchQueue.main.async {
            self.scannedCode = nil
            self.isShowingScanner = false
            self.isProcessingScan = false
        }
    }
    
    /// 📸 Inicia la sesión de captura
    func startScanning() {
        guard cameraAccessGranted else {
            print("⚠️ Permisos de cámara no concedidos")
            return
        }
        
        isProcessingScan = false  // 🔹 Resetea el flag para un nuevo escaneo
        
        if let session = setupCaptureSession() {
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }
    }
    
    /// 🛑 Detiene la sesión de captura
    func stopScanning() {
        captureSession?.stopRunning()
    }
    
    /// 🔹 Configura la sesión de captura
    func setupCaptureSession() -> AVCaptureSession? {
        let session = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("⚠️ Cámara no disponible, simulando QR")
            simulateScan()
            return nil
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            } else {
                print("⚠️ No se pudo agregar el input de la cámara.")
                return nil
            }
        } catch {
            print("⚠️ Error al acceder a la cámara: \(error.localizedDescription)")
            return nil
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("⚠️ No se pudo agregar el output de metadatos.")
            return nil
        }
        
        self.captureSession = session
        return session
    }
    
    /// 🔄 Simula un escaneo cuando la cámara no está disponible
    func simulateScan() {
        guard !isProcessingScan else { return }
        isProcessingScan = true

        print("🔹 Ejecutando simulateScan()...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.scannedCode = "https://ejemplo.com"
            self.saveScannedCode()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("✅ Simulación completada, cerrando solo el escáner")
                self.isShowingScanner = false
                self.isProcessingScan = false
            }
        }
    }
    
    /// 💾 Guarda el código QR en CoreData
    private func saveScannedCode() {
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
    
    /// 🔹 Captura el código QR escaneado
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard !isProcessingScan, let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let scannedText = metadataObject.stringValue else {
            return
        }

        isProcessingScan = true
        captureSession?.stopRunning()

        DispatchQueue.main.async {
            self.scannedCode = scannedText
            self.saveScannedCode()
            print("✅ Código escaneado: \(scannedText), cerrando escáner")

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isShowingScanner = false
                self.isProcessingScan = false
            }
        }
    }
}

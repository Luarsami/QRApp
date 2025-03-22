//
//  CameraPermissionService.swift
//  QRApp
//
//  Created by Luis Sarria on 22/03/25.
//

import AVFoundation
import Combine

class CameraPermissionService: ObservableObject {
    @Published var isAuthorized: Bool = false

    /// ✅ Verifica si la cámara tiene permiso
    func checkPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            isAuthorized = true
        case .notDetermined:
            requestPermission()
        default:
            isAuthorized = false
        }
    }

    /// 📌 Solicita acceso a la cámara
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.isAuthorized = granted
            }
        }
    }
}

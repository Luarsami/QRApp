//
//  ContentView.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingScanner = false
    @State private var scannedCode: String?
    @State private var showFlutter = false  // Estado para mostrar FlutterView

    var body: some View {
        VStack {
            if let scannedCode = scannedCode {
                Text("Código escaneado:")
                    .font(.headline)
                Text(scannedCode)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            } else {
                Text("Escanea un código QR")
            }
            
            // Botón para escanear QR
            Button(action: { isShowingScanner = true }) {
                Text("Escanear QR")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)

            // Botón para abrir el módulo Flutter
            Button(action: { showFlutter = true }) {
                Text("Abrir módulo Flutter")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 10)
        }
        // Modal para la cámara (Escaneo de QR)
        .sheet(isPresented: $isShowingScanner) {
            QRScannerView(isShowingScanner: $isShowingScanner, scannedCode: $scannedCode)
        }
        // Modal para FlutterView
        .fullScreenCover(isPresented: $showFlutter) {
            FlutterView()
        }
    }
}

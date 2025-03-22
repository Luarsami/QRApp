//
//  ContentView.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

//
//  ContentView.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

//
//  ContentView.swift
//  QRApp
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var scannerViewModel: QRScannerViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Text(scannerViewModel.scannedCode ?? "No hay código escaneado")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            NavigationLink(destination: QRScannerWrapperView().environmentObject(scannerViewModel)) {
                Text("Escanear QR")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)

            NavigationLink(destination: FlutterView()
                .environmentObject(scannerViewModel)
                .environmentObject(authViewModel)) {
                Text("Abrir módulo Flutter")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 10)

            Button(action: {
                authViewModel.logout()
                scannerViewModel.scannedCode = nil
                navigationManager.popToRoot()
            }) {
                Text("Cerrar sesión")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 30)
        }
        .navigationTitle("Inicio")
    }
}

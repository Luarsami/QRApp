//
//  FlutterManager.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import Flutter

class FlutterManager {
    static let shared = FlutterManager()
    let flutterEngine = FlutterEngine(name: "my_engine")

    private init() {
        flutterEngine.run()
    }
}

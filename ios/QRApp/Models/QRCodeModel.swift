//
//  QRCodeModel.swift
//  QRApp
//
//  Created by Luis Sarria on 22/03/25.
//

import Foundation
import CoreData

struct QRCodeModel {
    let id: UUID
    let content: String
    let dateScanned: Date

    init(entity: QRCode) {
        self.id = entity.id ?? UUID()
        self.content = entity.content ?? ""
        self.dateScanned = entity.dateScanned ?? Date()
    }
}

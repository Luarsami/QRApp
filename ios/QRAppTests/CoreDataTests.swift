//
//  CoreDataTests.swift
//  QRApp
//
//  Created by Luis Sarria on 21/03/25.
//

import XCTest
import CoreData
@testable import QRApp

class CoreDataTests: XCTestCase {
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
    }

    func testSaveQRCode() {
        let qrCode = QRCode(context: context)
        qrCode.id = UUID()
        qrCode.content = "Test QR Code"
        qrCode.dateScanned = Date()

        do {
            try context.save()
            let fetchRequest: NSFetchRequest<QRCode> = QRCode.fetchRequest()
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            XCTAssertEqual(results.first?.content, "Test QR Code")
        } catch {
            XCTFail("Error al guardar QR en CoreData")
        }
    }
}

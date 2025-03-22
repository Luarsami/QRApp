//
//  Persistence.swift
//  QRApp
//
//  Created by Luis Sarria on 20/03/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Modo de vista previa para SwiftUI (uso en simulaciones sin almacenamiento real)
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newQRCode = QRCode(context: viewContext)
            newQRCode.id = UUID()
            newQRCode.content = "Código de prueba \(i)"
            newQRCode.dateScanned = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error en vista previa de CoreData: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "QRApp")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Error al cargar CoreData: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Métodos auxiliares para CRUD en CoreData

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Error al guardar en CoreData: \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func fetchAllQRCodes() -> [QRCode] {
        let request: NSFetchRequest<QRCode> = QRCode.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \QRCode.dateScanned, ascending: false)]

        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error al obtener códigos QR: \(error.localizedDescription)")
            return []
        }
    }

    func deleteQRCode(_ qrCode: QRCode) {
        let context = container.viewContext
        context.delete(qrCode)
        saveContext()
    }
}

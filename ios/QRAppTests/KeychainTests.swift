//
//  KeychainTests.swift
//  QRApp
//
//  Created by Luis Sarria on 22/03/25.
//

import XCTest
@testable import QRApp

class KeychainTests: XCTestCase {
    func testSaveAndRetrievePIN() {
        let testPIN = "1234"
        KeychainHelper.savePIN(testPIN)
        let retrievedPIN = KeychainHelper.getPIN()
        XCTAssertEqual(retrievedPIN, testPIN, "El PIN guardado y recuperado deben coincidir")
    }
}

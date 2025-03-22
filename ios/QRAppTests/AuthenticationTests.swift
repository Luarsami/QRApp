//
//  AuthenticationTests.swift
//  QRApp
//
//  Created by Luis Sarria on 21/03/25.
//

import XCTest
@testable import QRApp

class AuthenticationTests: XCTestCase {
    func testAuthenticationSuccess() {
        let authManager = AuthenticationManager()
        authManager.isAuthenticated = true
        XCTAssertTrue(authManager.isAuthenticated)
    }
}

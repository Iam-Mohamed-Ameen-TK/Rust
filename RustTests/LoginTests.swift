//
//  LoginTests.swift
//  Rust
//
//  Created by Mohamed Ameen on 14/02/25.
//


import XCTest
@testable import Rust

class LoginTests: XCTestCase {
    var sut: LoginViewModel! 
    var mockAuth: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockAuth = MockAuthService()
        sut = LoginViewModel(authService: mockAuth)
    }
    
    override func tearDown() {
        sut = nil
        mockAuth = nil
        super.tearDown()
    }
    
    func testSuccessfulLogin() {
        // Given
        let expectation = XCTestExpectation(description: "Successful login")
        sut.email = "test@example.com"
        sut.password = "password123"
        
        // When
        mockAuth.mockResult = .success(())
        sut.login()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.sut.isLoggedIn)
            XCTAssertFalse(self.sut.showAlert)
            XCTAssertNil(self.sut.alertMessage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFailedLogin() {
        // Given
        let expectation = XCTestExpectation(description: "Failed login")
        sut.email = "test@example.com"
        sut.password = "wrongpassword"
        let mockError = NSError(domain: "auth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
        
        // When
        mockAuth.mockResult = .failure(mockError)
        sut.login()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.sut.isLoggedIn)
            XCTAssertTrue(self.sut.showAlert)
            XCTAssertEqual(self.sut.alertMessage, "Invalid credentials")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// Mock Auth Service
class MockAuthService {
    var mockResult: Result<Void, Error>?
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}

// ViewModel
class LoginViewModel {
    private let authService: MockAuthService
    var email: String = ""
    var password: String = ""
    var isLoggedIn: Bool = false
    var showAlert: Bool = false
    var alertMessage: String?
    
    init(authService: MockAuthService) {
        self.authService = authService
    }
    
    func login() {
        authService.signIn(withEmail: email, password: password) { result in
            switch result {
            case .success:
                self.isLoggedIn = true
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
}

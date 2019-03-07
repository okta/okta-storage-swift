//
//  OktaSecureStorageTests.swift
//  OktaSecureStorageTests
//
//  Created by Ildar Abdullin on 3/5/19.
//  Copyright © 2019 Okta. All rights reserved.
//

import XCTest
@testable import OktaSecureStorage

class OktaSecureStorageTests: XCTestCase {

    var secureStorage : OktaSecureStorage!
    
    override func setUp() {
        secureStorage = OktaSecureStorage()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetAndGetSuccessCases() {
        
        do {
            try secureStorage.set("token", forKey: "john doe", behindBiometrics: false)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set("token", forKey: "john doe", behindBiometrics: true)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }

        do {
            try secureStorage.set("token", forKey: "john doe", behindBiometrics: false, accessibility:kSecAttrAccessibleAlways)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        var accessGroup : String? = nil
        do {
            let seedId = try secureStorage.bundleSeedId()
            accessGroup = seedId + ".com.okta.oktasecurestorage"
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
            return
        }

        do {
            try secureStorage.set("token", forKey: "john doe", behindBiometrics: false, accessGroup:accessGroup!)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }

        do {
            try secureStorage.set("token",
                                  forKey: "john doe",
                                  behindBiometrics: false,
                                  accessGroup:accessGroup,
                                  accessibility:kSecAttrAccessibleAfterFirstUnlock)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch {
            XCTFail("Keychain operation failed - \(error)")
        }

        do {
            try secureStorage.set("token",
                                  forKey: "john doe",
                                  behindBiometrics: true,
                                  accessGroup:accessGroup,
                                  accessibility:kSecAttrAccessibleAfterFirstUnlock)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!, forKey: "john doe", behindBiometrics: false)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!, forKey: "john doe", behindBiometrics: true)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!, forKey: "john doe", behindBiometrics: false, accessibility:kSecAttrAccessibleAlways)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!, forKey: "john doe", behindBiometrics: false, accessGroup:accessGroup!)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!,
                                  forKey: "john doe",
                                  behindBiometrics: false,
                                  accessGroup:accessGroup,
                                  accessibility:kSecAttrAccessibleAfterFirstUnlock)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!,
                                  forKey: "john doe",
                                  behindBiometrics: true,
                                  accessGroup:accessGroup,
                                  accessibility:kSecAttrAccessibleAfterFirstUnlock)
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch {
            XCTFail("Keychain operation failed - \(error)")
        }
    }
}

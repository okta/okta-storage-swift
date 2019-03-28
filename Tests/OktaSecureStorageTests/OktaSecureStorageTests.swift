/*
 * Copyright 2019 Okta, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
import LocalAuthentication
@testable import OktaSecureStorage

class OktaSecureStorageTests: XCTestCase {

    var secureStorage : OktaSecureStorage!
    
    override func setUp() {
        secureStorage = OktaSecureStorage()
    }

    override func tearDown() {
        try? secureStorage.clear()
    }

    func testSetAndGetWithStringSuccessCases() {
        do {
            try secureStorage.set("token", forKey: "account1", behindBiometrics: false)
            let result = try secureStorage.get(key: "account1")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set("token", forKey: "account2", behindBiometrics: true)
            let result = try secureStorage.get(key: "account2")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }

        do {
            try secureStorage.set("token", forKey: "account3", behindBiometrics: false, accessibility:kSecAttrAccessibleAlways)
            let result = try secureStorage.get(key: "account3")
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
            try secureStorage.set("token", forKey: "account4", behindBiometrics: false, accessGroup:accessGroup!)
            let result = try secureStorage.get(key: "account4")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }

        do {
            try secureStorage.set("token",
                                  forKey: "account5",
                                  behindBiometrics: false,
                                  accessGroup:accessGroup,
                                  accessibility:kSecAttrAccessibleAfterFirstUnlock)
            let result = try secureStorage.get(key: "account5")
            XCTAssertEqual("token", result)
        } catch {
            XCTFail("Keychain operation failed - \(error)")
        }

        do {
            try secureStorage.set("token",
                                  forKey: "account6",
                                  behindBiometrics: true,
                                  accessGroup:accessGroup,
                                  accessibility:kSecAttrAccessibleAfterFirstUnlock)
            let result = try secureStorage.get(key: "account6")
            XCTAssertEqual("token", result)
        } catch {
            XCTFail("Keychain operation failed - \(error)")
        }
    }

    func testSetAndGetWithDataSuccessCases() {
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!, forKey: "account7", behindBiometrics: false)
            let result = try secureStorage.getData(key: "account7")
            XCTAssertEqual("token".data(using: .utf8)!, result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!, forKey: "account8", behindBiometrics: true)
            let result = try secureStorage.getData(key: "account8")
            XCTAssertEqual("token".data(using: .utf8)!, result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!, forKey: "account9", behindBiometrics: false, accessibility:kSecAttrAccessibleAlways)
            let result = try secureStorage.getData(key: "account9")
            XCTAssertEqual("token".data(using: .utf8)!, result)
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
            try secureStorage.set(data:"token".data(using: .utf8)!, forKey: "account10", behindBiometrics: false, accessGroup:accessGroup!)
            let result = try secureStorage.getData(key: "account10")
            XCTAssertEqual("token".data(using: .utf8)!, result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!,
                                  forKey: "account11",
                                  behindBiometrics: false,
                                  accessGroup:accessGroup,
                                  accessibility:kSecAttrAccessibleAfterFirstUnlock)
            let result = try secureStorage.getData(key: "account11")
            XCTAssertEqual("token".data(using: .utf8)!, result)
        } catch {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.set(data:"token".data(using: .utf8)!,
                                  forKey: "account12",
                                  behindBiometrics: true,
                                  accessGroup:accessGroup,
                                  accessibility:kSecAttrAccessibleAfterFirstUnlock)
            let result = try secureStorage.getData(key: "account12")
            XCTAssertEqual("token".data(using: .utf8)!, result)
        } catch {
            XCTFail("Keychain operation failed - \(error)")
        }
    }

    func testSetWithApplicationPassword() {
        secureStorage = OktaSecureStorage(applicationPassword: "password")
        do {
            try secureStorage.set("token", forKey: "john doe", behindBiometrics: false)
            let result = try secureStorage.getData(key: "john doe")
            XCTAssertEqual("token".data(using: .utf8)!, result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
    }

    func testSetWithWrongApplicationPassword() {
#if targetEnvironment(simulator)
        return
#else
        secureStorage = OktaSecureStorage(applicationPassword: "password")
        do {
            try secureStorage.set("token", forKey: "john doe", behindBiometrics: false)
            secureStorage = OktaSecureStorage(applicationPassword: "wrong_password")
            let result = try secureStorage.get(key: "john doe")
            XCTFail("Failure is expected, got data - \(result)")
        } catch let error as NSError {
            XCTAssertEqual(-25293, error.code)
        }
        
        do {
            secureStorage = OktaSecureStorage(applicationPassword: "password")
            let result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
#endif
    }

    func testSetAndGetWithEmptyApplicationPassword() {
#if targetEnvironment(simulator)
        return
#else
        secureStorage = OktaSecureStorage(applicationPassword: "")
        do {
            try secureStorage.set("token", forKey: "john doe", behindBiometrics: false)
            XCTFail("Failure is expected")
        } catch let error as NSError {
            XCTAssertEqual(-25293, error.code)
        }
#endif
    }

    func testDeleteSuccessCase() {
        do {
            try secureStorage.set("token", forKey: "john doe", behindBiometrics: false)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }

        do {
            try secureStorage.delete(key: "john doe")
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }

        do {
            _ = try secureStorage.get(key: "john doe")
            XCTAssert(false, "Exception expected here")
        } catch let error as NSError {
            XCTAssert(error.code == errSecItemNotFound)
        }
    }

    func testClearSuccessCase() {
        do {
            try secureStorage.set("token", forKey: "account0", behindBiometrics: false)
            try secureStorage.set("token", forKey: "account1", behindBiometrics: false)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            try secureStorage.clear()
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
        
        do {
            _ = try secureStorage.get(key: "account0")
            XCTFail("Exception expected here")
        } catch let error as NSError {
            XCTAssert(error.code == errSecItemNotFound)
        }

        do {
            _ = try secureStorage.get(key: "account1")
            XCTFail("Exception expected here")
        } catch let error as NSError {
            XCTAssert(error.code == errSecItemNotFound)
        }
    }
    
    func testTouchIDSupported() {
        let laContext = LAContext()
        var touchIdSupported = false
        if #available(iOS 11.0, *) {
            let touchIdEnrolled = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            touchIdSupported = laContext.biometryType == .touchID && touchIdEnrolled
        } else {
            touchIdSupported = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        }
        XCTAssert(touchIdSupported == secureStorage.isTouchIDSupported())
    }

    func testFaceIDSupported() {
        let  laContext = LAContext()
        var faceIdSupported = false
        let biometricsEnrolled = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        if #available(iOS 11.0, *) {
            faceIdSupported = laContext.biometryType == .faceID
        }
        let faceIDSupported = biometricsEnrolled && faceIdSupported
        XCTAssert(faceIDSupported == secureStorage.isFaceIDSupported())
    }

    func testBundleSeedIdSuccessCase() {
        do {
            let seedId = try secureStorage.bundleSeedId()
            XCTAssertEqual(seedId, "HJPMDS86QA")
        } catch let error as NSError {
            XCTFail("Keychain operation failed - \(error)")
        }
    }

    func testDataOverwriteSuccessCase() {
        do {
            try secureStorage.set("token", forKey: "john doe", behindBiometrics: false)
            var result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("token", result)
            try secureStorage.set("password", forKey: "john doe", behindBiometrics: false)
            result = try secureStorage.get(key: "john doe")
            XCTAssertEqual("password", result)
        } catch let error {
            XCTFail("Keychain operation failed - \(error)")
        }
    }

    func testSetFailureCases() {
        do {
            try secureStorage.set("token", forKey: "", behindBiometrics: false, accessibility:"" as CFString)
            XCTFail("Exception expected here")
        } catch let error as NSError {
            XCTAssert(error.code == errSecParam)
        }

        do {
            try secureStorage.set("token", forKey: "", behindBiometrics: true, accessibility:"" as CFString)
            XCTFail("Exception expected here")
        } catch let error as NSError {
            XCTAssert(error.code == errSecParam)
        }
    }

    func testGetFailureCases() {
        do {
            _ = try secureStorage.get(key: "")
            XCTFail("Exception expected here")
        } catch let error as NSError {
            XCTAssert(error.code == errSecItemNotFound)
        }
    }
}

/*
 * Copyright (c) 2017, Okta, Inc. and/or its affiliates. All rights reserved.
 * The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
 *
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and limitations under the License.
 */

import Foundation

open class OktaSecureStorage: NSObject {
    
    static let dataErrorDomain = "com.okta.securestorage.data"

    static let keychainErrorDomain = "com.okta.securestorage.keychain"

    @objc open func set(data: String, forKey key: String, behindBiometrics: Bool) throws {

        try set(data: data, forKey: key, behindBiometrics: behindBiometrics, accessGroup: nil, accessibility: nil)
    }
    
    @objc open func set(data: String,
                        forKey key: String,
                        behindBiometrics: Bool,
                        accessibility: CFString? = kSecAttrAccessibleWhenUnlockedThisDeviceOnly) throws {

        try set(data: data, forKey: key, behindBiometrics: false, accessGroup: nil, accessibility: accessibility)
    }
    
    @objc open func set(data: String,
                        forKey key: String,
                        behindBiometrics: Bool,
                        accessGroup: String? = nil) throws {

        try set(data: data, forKey: key, behindBiometrics: behindBiometrics, accessGroup: accessGroup, accessibility: nil)
    }
    
    @objc open func set(data: String,
                        forKey key: String,
                        behindBiometrics: Bool,
                        accessGroup: String? = nil,
                        accessibility: CFString? = nil) throws {
        
        guard let bytesStream = data.data(using: .utf8) else {
            throw NSError(domain: OktaSecureStorage.dataErrorDomain, code: -1, userInfo: nil)
        }

        var query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: "OktaSecureStorage",
            kSecValueData as String: bytesStream,
            kSecAttrAccount as String: key,
            ] as [String : Any]
        
        if behindBiometrics {
            
            var cfError: Unmanaged<CFError>?
            
            let secAccessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                                   accessibility ?? kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                                   SecAccessControlCreateFlags.touchIDCurrentSet, // check for ios version
                                                                   &cfError)
            
            if let error: Error = cfError?.takeRetainedValue() {
                
                throw error
            }
            
            query[kSecAttrAccessControl as String] = secAccessControl

        } else {
            query[kSecAttrAccessible as String] = accessibility ?? kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let cfDictionary = query as CFDictionary
        // Delete existing (if applicable)
        SecItemDelete(cfDictionary)
        
        let errorCode = SecItemAdd(cfDictionary, nil)
        if errorCode != noErr {
            throw NSError(domain: OktaSecureStorage.keychainErrorDomain, code: Int(errorCode), userInfo: nil)
        }
    }

    @objc open func get(key: String) throws -> String {
        
        let q = [
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccount as String: key
            ] as CFDictionary
        
        var ref: AnyObject? = nil
        
        let sanityCheck = SecItemCopyMatching(q, &ref)
        guard sanityCheck == noErr else {
            throw NSError(domain: OktaSecureStorage.keychainErrorDomain, code: Int(sanityCheck), userInfo: nil)
        }
        guard let data = ref as? Data else {
            throw NSError(domain: OktaSecureStorage.keychainErrorDomain, code: Int(sanityCheck), userInfo: nil)
        }
        
        return String(data: data, encoding: .utf8)!
    }

    @objc open func get(key: String, biometricPrompt prompt: String) throws -> String {
        
        return ""
    }

    @objc open func delete(key: String) throws {
        
    }
    
    @objc open func isTouchIDSupported() {
        
        
    }

    @objc open func isFaceIDSupported() {
        
        
    }
}

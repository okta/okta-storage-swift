[<img src="https://devforum.okta.com/uploads/oktadev/original/1X/bf54a16b5fda189e4ad2706fb57cbb7a1e5b8deb.png" align="right" width="256px"/>](https://devforum.okta.com/)
[![Version](https://img.shields.io/cocoapods/v/OktaStorage.svg?style=flat)](http://cocoapods.org/pods/OktaStorage)
[![License](https://img.shields.io/cocoapods/l/OktaStorage.svg?style=flat)](http://cocoapods.org/pods/OktaStorage)
[![Platform](https://img.shields.io/cocoapods/p/OktaStorage.svg?style=flat)](http://cocoapods.org/pods/OktaStorage)
[![Swift](https://img.shields.io/badge/swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/)

# Okta Secure Storage Library

This library is a Swift wrapper around the iOS LocalAuthentication and Security frameworks. The library provides convenient APIs to utilize keychain services by giving your app a mechanism to store small bits of user data in an encrypted database. The keychain is not limited to passwords and tokens. You can store other secrets that the user explicitly cares about, such as credit card information or even short notes.

The storage library includes the following features:
1. Get, set and delete keychain items
2. Store to the keychain behind a biometric factor such as fingerprint or face ID


**Table of Contents**

<!-- TOC depthFrom:2 depthTo:3 -->

- [Usage](#usage)
- [Create instance of OktaSecureStorage class](#create-instance-of-oktasecurestorage-class)
- [Save data to keychain](#save-data-to-keychain)
- [Save data to keychain behind a biometric factor](#save-data-to-keychain-behind-a-biometric-factor)
- [Load data from keychain](#load-data-from-keychain)
- [Delete data from keychain](#delete-data-from-keychain)
- [API Reference](#api-reference)
- [How to use this libary in Objective-C project](#how-to-use-this-libary-in-objective-c-project)

<!-- /TOC -->

## Usage

Add `import OktaSecureStorage` to your source code

### Create instance of OktaSecureStorage class

```swift
let oktaStorage = OktaSecureStorage()
or
let oktaStorage = OktaSecureStorage(applicationPassword: "user_password")
```

### Save data to keychain

```swift
do {
    try oktaStorage.set(string: "password", forKey: "jdoe")
} catch let error {
    // Handle error
}
```

### Save data to keychain behind a biometric factor

```swift
do {
    try oktaStorage.set(string: "password", forKey: "jdoe" behindBiometrics: true)
} catch let error {
    // Handle error
}
```

### Load data from keychain

```swift
do {
    let password = try oktaStorage.get("jdoe")
} catch let error {
    // Handle error
}
```

### Delete data from keychain

```swift
do {
    try oktaStorage.delete("jdoe")
} catch let error {
    // Handle error
}
```

## API Reference

### init(applicationPassword password: String? = nil)

Initializes OktaSecureStorage instance. The optional parameter `applicationPassword` allows items in the keychain to be secured using an additional password. This way, if the user does not have a passcode or Touch ID set up, the items will still be secure, and it adds an extra layer of security if they do have a passcode set

### set(string: String, forKey key: String) -> Bool throws

Stores an item securely in the keychain. Method returns true on success and false on error.

```swift
do {
    try oktaStorage.set("password", forKey: "jdoe")
} catch let error {
    // Handle error
}
```

### set(string: String, forKey key: String, behindBiometrics: Bool) throws

Stores an item securely and additionally accepts `behindBiometrics` parameter. Set this parameter to `true` if you want to store keychain item behind a biometric factor such as touch ID or face ID.

```swift
do {
    try oktaStorage.set("password", forKey: "jdoe" behindBiometrics: true)
} catch let error {
    // Handle error
}
```

### set(string: String, forKey key: String, behindBiometrics: Bool, accessGroup: String) throws

Stores an item securely and additionally accepts `accessGroup` identifier. Use `accessGroup` to share keychain items between apps. Two or more apps that are in the same group can share keychain items because they share a common keychain access group entitlement. For more details, see [Sharing Access to Keychain Items Among a Collection of Apps](https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps)

```swift
do {
    try oktaStorage.set("password",
                        forKey: "jdoe",
                        accessGroup: "TEAMSEEDID.com.mycompany.sharedkeychain")
} catch let error {
    // Handle error
}
```

### set(string: String, forKey key: String, behindBiometrics: Bool, accessibility: CFString) throws

Stores an item securely and additionally accepts `accessibility` parameter. Use  `accessibility` parameter to indicate when a keychain item is accessible. Choose the most restrictive option that meets your app’s needs so that the system can protect that item to the greatest extent possible. Possible values are listed [here](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1679100). Please note that default value for accessibility parameter is kSecAttrAccessibleWhenUnlockedThisDeviceOnly - items with this attribute do not migrate to a new device.

```swift
do {
    try oktaStorage.set("password",
                        forKey: "jdoe",
                        accessibility: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
} catch let error {
    // Handle error
}
```

### Additional helper functions

```swift
set(string: String,
    forKey key: String,
    accessGroup: String? = nil,
    accessibility: CFString?) throws

set(data: Data,
    forKey key: String) throws
    
set(data: Data,
    forKey key: String,
    behindBiometrics: Bool) throws

set(data: Data,
    forKey key: String,
    behindBiometrics: Bool,
    accessGroup: String) throws

set(data: Data,
    forKey key: String,
    behindBiometrics: Bool,
    accessibility: CFString) throws

set(data: Data,
    forKey key: String,
    accessGroup: String?,
    accessibility: CFString?) throws
```

### get(key: String, biometricPrompt prompt: String? = nil) -> String throws

Retrieves the stored keychain item from the keychain. Additionally method expects optional `prompt` message for the keychain item stored behind a biometric factor. 
> * Note: iOS will show native Touch ID or Face ID message view in case of biometrics enabled storage. It means that function may be blocked and wait for the user's action. It is advised to call  `get` function in a background thread

```swift
DispatchQueue.global().async {
    do {
        let password = try oktaStorage.get("jdoe", prompt: “Please use Touch ID or Face ID to sign in”)
    } catch let error {
        // Handle error
    }
}
```

### getData(key: String, biometricPrompt prompt: String? = nil) -> Data throws

Retrieves the stored keychain item from the keychain. Additionally method expects optional `prompt` message for the keychain item stored behind a biometric factor. 
> * Note: iOS will show native Touch ID or Face ID message view in case of biometrics enabled storage. It means that function may be blocked and wait for the user's action. It is advised to call  `getData` function in a background thread

```swift
DispatchQueue.global().async {
    do {
        let passwordData = try oktaStorage.getData("jdoe", prompt: “Please use Touch ID or Face ID to sign in”)
    } catch let error {
        // Handle error
    }
}
```

### delete(key: String) throws

Removes the stored keychain item from the keychain

```swift
do {
    try oktaStorage.delete("jdoe")
} catch let error {
    // Handle error
}
```

### clear()  throws

Removes all keychain items from the keychain

```swift
do {
    try oktaStorage.clear()
} catch let error {
    // Handle error
}
```

### isTouchIDSupported -> Bool

Checks whether device enrolled with Touch ID. If the biometry is not available, not enrolled or locked out, then the function call will return false.

```swift
let isTouchIDSupported = storageManager.isTouchIDSupported()
```

### isFaceIDSupported -> Bool

Checks whether device enrolled with Face ID. If the biometry is not available, not enrolled or locked out, then the function call will return false.

```swift
let isFaceIDSupported = storageManager.isFaceIDSupported()
```

## How to use this libary in Objective-C project
1. Include auto generated swift header file into your .m file. Swift header file contains objective-c representation of Okta swift classes. Please note that the name of header file consists of your project name and “-Swift” suffix. For example if your project name is AuthApp, then auto generated header file name will be “AuthApp-Swift.h”
2. Start using programming components available in swift header file

Example:
```objective-c
OktaSecureStorage *storage = [OktaSecureStorage new];
NSError *error;
BOOL success = [storage setWithString:"password" forKey:"jdoe" error:&error];
if (success) {
    NSString *password = [storage getWithKey:@"jdoe" error:&error];
    if (password != nil) {
        success = [storage deleteWithKey:@"jdoe" error:&error];
    }
}
```

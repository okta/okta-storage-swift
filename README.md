[<img src="https://devforum.okta.com/uploads/oktadev/original/1X/bf54a16b5fda189e4ad2706fb57cbb7a1e5b8deb.png" align="right" width="256px"/>](https://devforum.okta.com/)

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
- [Error handling](#error-handling)
- [API Reference](#api-reference)
- [How to use this libary in Objective-C project](#how-to-use-this-libary-in-objective-c-project)

<!-- /TOC -->

## Usage

Add `import OktaSecureStorage` to your source code

### Create instance of OktaSecureStorage class

```swift
let oktaStorage = OktaSecureStorage()
```

### Save data to keychain

```swift
let success = oktaStorage.set(string: "password", forKey: "jdoe")
```

### Save data to keychain behind a biometric factor

```swift
let success = oktaStorage.set(string: "password", forKey: "jdoe" behindBiometrics: true)
```

### Load data from keychain

```swift
let password = oktaStorage.get("jdoe")
```

### Delete data from keychain

```swift
let success = oktaStorage.delete("jdoe")
```

### Error handling

API functions throw NSError object. Please add requried handling in your code.
Example:

```swift
do {
    try oktaStorage.set(string: "password", forKey: "jdoe", behindBiometrics: true)
} catch let error as NSError {
    print("Error: \(error.domain)")
}
```

## API Reference

### set(string: String, forKey key: String) -> Bool throws

Stores an item securely in the keychain. Method returns true on success and false on error.

```swift
let success = oktaStorage.set("password", forKey: "jdoe")
```

### set(string: String, forKey key: String, behindBiometrics: Bool) throws

Stores an item securely and additionally accepts `behindBiometrics` parameter. Set this parameter to `true` if you want to store keychain item behind a biometric factor such as touch ID or face ID.

```swift
let success = oktaStorage.set("password", forKey: "jdoe" behindBiometrics: true)
```

### set(string: String, forKey key: String, behindBiometrics: Bool, accessGroup: String) throws

Stores an item securely and additionally accepts `accessGroup` identifier. Use `accessGroup` to share keychain items between apps. Two or more apps that are in the same group can share keychain items because they share a common keychain access group entitlement. For more details, see [Sharing Access to Keychain Items Among a Collection of Apps](https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps)

```swift
let success = oktaStorage.set("password",
                              forKey: "jdoe",
                              accessGroup: "TEAMSEEDID.com.mycompany.sharedkeychain")
```

### set(string: String, forKey key: String, behindBiometrics: Bool, accessibility: CFString) throws

Stores an item securely and additionally accepts `accessibility` parameter. Use  `accessibility` parameter to indicate when a keychain item is accessible. Choose the most restrictive option that meets your app’s needs so that the system can protect that item to the greatest extent possible. Possible values are listed [here](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1679100). Please note that default value for accessibility parameter is kSecAttrAccessibleWhenUnlockedThisDeviceOnly - items with this attribute do not migrate to a new device.

```swift
let success = oktaStorage.set("password",
                              forKey: "jdoe",
                              accessibility: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
```

### Additional helper functions

```swift
set(string: String,
    forKey key: String,
    accessGroup: String? = nil,
    accessibility: CFString?) throws

set(data: Data,
    forKey key: String) trows
    
set(data: Data,
    forKey key: String,
    behindBiometrics: Bool) trows

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
> * Note: iOS will show native Touch ID or Face ID message view in case of biometrics enabled storage. It means that function may be blocked and wait for the user's action.

```swift
let password = oktaStorage.get("jdoe", prompt: “Please use Touch ID or Face ID to sign in”)
```

### delete(key: String) throws

Removes the stored keychain item from the keychain

```swift
let success = oktaStorage.delete("jdoe")
```

### clear()  throws

Removes all keychain items from the keychain

```swift
let success = oktaStorage.delete("jdoe")
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

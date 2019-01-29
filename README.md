[<img src="https://devforum.okta.com/uploads/oktadev/original/1X/bf54a16b5fda189e4ad2706fb57cbb7a1e5b8deb.png" align="right" width="256px"/>](https://devforum.okta.com/)

# Okta Secure Storage Library

This library is a Swift wrapper around the iOS CommonCrypto, LocalAuthentication and Security frameworks. Library provides convenient API to utilize keychain services by giving your app a mechanism to store small bits of user data in an encrypted database. The keychain is not limited to passwords and tokens. You can store other secrets that the user explicitly cares about, such as credit card information or even short notes.

Library supports 3 different ways how to store data in keychain:
1. Store data to keychain
2. Store to keychain data that is further encrypted with AES256 encryption algorithm. Encryption key is provided by the developer via API
3. Store to keychain behind a biometric factor such as fingerprint or face ID

Configuration parameters:
1. AccountId - optional account name
2. GroupdId - optional access group. Two or more apps that are in the same group can share keychain items because thet share a common keychain access group entitlement. For more details, see [Sharing Access to Keychain Items Among a Collection of Apps](https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps)

**Table of Contents**

<!-- TOC depthFrom:2 depthTo:3 -->

- [Getting Started](#getting-started)
- [Create instance of OktaSecureStorageManager](#create-instance-of-oktasecurestoragemanager)
- [Save data to keychain](#save-data-to-keychain)
- [Load data from keychain](#load-data-from-keychain)
- [API Reference](#api-reference)
- [save(data: String!)](#save-data)
- [save(data: String!, withPassCodePin passCodePin: String!)](#save-data-with-passcodepin)
- [storedData](#storeddata)
- [storedDataWithPassCodePin(pin: String)](#storeddatawithpasscodepin)
- [storedDataWithPrompt(userPrompt: String)](#storeddatawithprompt)
- [isDataStored](#isdatastored)
- [isSupportedOnTheDevice](#issupportedonthedevice)
- [deleteData](#deletedata)
- [How to use this libary in Objective-C project](#how-to-use-this-libary-in-objective-c-project])

<!-- /TOC -->

## Getting Started

### Create instance of OktaSecureStorageManager

It is really easy to start using library. Find OktaSecureStorageManager class and call factory method secureStorageManager with the following parameters:
- type - secure storage manager type. Could be one of the following: plainText, encryption or biometrics
- accountId - optional account name 
- groupId - optional group id


```swift
let storageManager = OktaSecureStorageManager.secureStorageManager(type: .plainText, accountId: "jdoe", groupId: "com.mycompany.sharedkeychain")
```

### Save data to keychain

```swift
storageManager.save(data: "Token Data")
```

### Load data from keychain

```swift
let token = storageManager.storedData()
```

## API Reference

### save(data: String!)

Saves data without using pin. Function returns reference to the stored data. Function will return nil if the storage type doesn’t support storage without pin.

```swift
let storedData = storageManager.save(data: “Data to store”)
```

### save(data: String!, withPassCodePin passCodePin: String!)

Saves data using passcode pin. In case if the pin is not required by the storage manager pin parameter will be ignored. Function returns reference to the stored data.

```swift
let storedData = storageManager.save(data: “Data to store””, withPassCodePin: “Encryption Key”)
```

### storedData

Returns stored data without using passcode pin. Returns nil if not stored or requires a pin to read encrypted data based on type of storage.
> * Note: iOS will show native Touch ID or Face ID message view in case of biometrics enabled storage. It means that function may be blocked and wait for the user's action

```swift
let token = storageManager.storedData()
```

### storedDataWithPassCodePin(pin: String)

Returns stored data using passcode pin. In case if the pin is not required by storage manager pin parameter will be ignored.
> * Note: iOS will show native Touch ID or Face ID message view in case of biometrics enabled storage. It means that function may be blocked and wait for the user's action

```swift
let token = storageManager.storedDataWithPassCodePin(pin: “1234”)
```

### storedDataWithPrompt(userPrompt: String)

Returns stored data without using passcode pin. Method expects user prompt message based on device type and support. Returns nil if not stored or requires a pin to read encrypted data based on type of storage
> * Note: iOS will show native Touch ID or Face ID message view in case of biometrics enabled storage. It means that function may be blocked and wait for the user's action

```swift
let token = storageManager.storedDataWithPrompt(userPrompt: “Please use Touch ID to sign in”)
```

### isDataStored

Checks if token is stored using concrete instance of storage manager. Returns true if token is stored:

```swift
let isTokenStored = storageManager.isDataStored()
```

### isSupportedOnTheDevice

Checks whether created OktaSecureStorageManager instance can be used on the current device. Returns true if the OktaSecureStorageManager is supported on the device. OktaSecureStorageManager of type biometrics can return false if Touch ID and Face ID are not available on the device

```swift
let isSupported = storageManager.isSupportedOnTheDevice()
```

### deleteData

Deletes data from secure storage. If data is deleted returns true. If data does not exist returns false

```swift
let result = storageManager.deleteData()
```

## How to use this libary in Objective-C project:
1. Include auto generated swift header file into your .m file. Swift header file contains objective-c representation of Okta swift classes. Please note that the name of header file consists of your project name and “-Swift” suffix. For example if your project name is AuthApp, then auto generated header file name will be “AuthApp-Swift.h”
2. Start using programming components available in swift header file

Example:
```objective-c
OktaSecureStorageManager *manager = [OktaSecureStorageManager secureStorageManagerWithType:OktaStorageManagerTypeEncryption
                                                                                 accountId:@“jdoe”
                                                                                   groupId:@"com.mycompany.sharedkeychain"];
[manager saveData:@"Access Token" withPassCodePin:@"Encryption Key"]; 
NSString *token = [manager storedTokenWithPassCodePin:@"Encryption Key"];
```

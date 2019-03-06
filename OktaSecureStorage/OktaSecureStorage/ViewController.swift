//
//  ViewController.swift
//  OktaSecureStorage
//
//  Created by Ildar Abdullin on 3/5/19.
//  Copyright © 2019 Okta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let storage = OktaSecureStorage()
        let bundleSeedId = try! storage.bundleSeedId()
        let accessGroup = bundleSeedId + ".com.okta.oktasecurestorage"
        
        do {
            try storage.set(data:"token".data(using: .utf8)!, forKey: "john doe", behindBiometrics: false, accessGroup:accessGroup)
            let result = try storage.get(key: "john doe")
            print("\(result)")
        } catch let error {
            print("Keychain operation failed - \(error)")
        }
    }


}


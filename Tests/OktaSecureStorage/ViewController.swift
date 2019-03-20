//
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

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var storeStackView: UIStackView!
    @IBOutlet weak var biometricImageView: UIImageView!
    @IBOutlet weak var readStackView: UIStackView!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retrievedPasswordTextField: UITextField!
    
    let secureStorage = OktaSecureStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readStackView.isHidden = true
        if secureStorage.isFaceIDSupported() {
            biometricImageView.image = UIImage(named: "face-id")
        } else if (secureStorage.isTouchIDSupported()) {
            biometricImageView.image = UIImage(named: "touch-id")
        } else {
            biometricImageView.isHidden = true
        }
    }

    @IBAction func onStoreButtonTap(_ sender: Any) {
        do {
            let biometricsEnabled = secureStorage.isFaceIDSupported() || secureStorage.isTouchIDSupported()
            try secureStorage.set(passwordTextField.text!,
                                  forKey: "user",
                                  behindBiometrics: biometricsEnabled)
            readStackView.isHidden = false
            storeStackView.isHidden = true
            passwordTextField.resignFirstResponder()
        } catch let error as NSError {
            let alert = UIAlertController(title: "Error", message: "Error with error code - \(error.code)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func onReadButtonTap(_ sender: Any) {
        DispatchQueue.global().async {
            do {
                let password = try self.secureStorage.get(key: "user")
                DispatchQueue.main.async {
                    self.retrievedPasswordTextField.text = password
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Error with error code - \(error.code)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func onClearButtonTap(_ sender: Any) {
        do {
            try secureStorage.clear()
            readStackView.isHidden = true
            storeStackView.isHidden = false
            passwordTextField.text = ""
        } catch let error as NSError {
            let alert = UIAlertController(title: "Error", message: "Error with error code - \(error.code)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}


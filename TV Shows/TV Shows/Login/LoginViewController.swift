//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 14.07.2021..
//

import UIKit

class LoginViewController: UIViewController {
    
    
    // MARK: - Outlets

    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var checkBoxButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var eyeButton: UIButton!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.textColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
        eyeButton.setImage(UIImage(named: "open_eye"), for: .normal)
        loginButton.layer.cornerRadius = 15.0
        emailTextField.attributedPlaceholder = NSAttributedString(string:"username",
                                                                     attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"password",
                                                                     attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    // MARK: - Actions
    
    @available(iOS 13.0, *)
    @IBAction func CheckBoxButtonAction(_ sender: Any) {
        if checkBoxButton.image(for: .normal) ==  UIImage(named: "ic-checkbox-selected"){
            checkBoxButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
        }else{
            checkBoxButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .normal)
        }
    }
    
    @IBAction func hideShowPasswordAction(_ sender: Any) {
        if eyeButton.image(for: .normal) == UIImage(named: "open_eye"){
            passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
            eyeButton.setImage(UIImage(named: "closed_eye"), for: .normal)
        }else{
            passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
            eyeButton.setImage(UIImage(named: "open_eye"), for: .normal)
        }
    }
}

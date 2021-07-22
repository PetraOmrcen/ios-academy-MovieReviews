//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 14.07.2021..
//

import UIKit

final class LoginViewController: UIViewController {
    
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
        
        emailTextField.textColor = .white
        passwordTextField.textColor = .white
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .selected)
        eyeButton.setImage(UIImage(named: "closed_eye"), for: .normal)
        loginButton.layer.cornerRadius = 15.0
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        emailTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: attributes)
    }
    
    // MARK: - Actions
    
    @IBAction func checkBoxButtonAction(_ sender: Any) {
        checkBoxButton.isSelected.toggle()
    }
    
    @IBAction func hideShowPasswordAction(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "closed_eye" : "open_eye"
        eyeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

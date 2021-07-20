//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 14.07.2021..
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var LoginButton: UIButton!
    @IBOutlet private weak var RegisterButton: UIButton!
    @IBOutlet private weak var CheckBoxButton: UIButton!
    @IBOutlet private weak var EmailTextField: UITextField!
    @IBOutlet private weak var PasswordTextField: UITextField!
    
    
    private var state = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginButton.layer.cornerRadius = 15.0
        EmailTextField.attributedPlaceholder = NSAttributedString(string:"username",
                                                                     attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string:"password",
                                                                     attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    
    @available(iOS 13.0, *)
    @IBAction func CheckBoxButtonAction(_ sender: Any) {
        if state == 0 {
            //CheckBoxButton.setBackgroundImage(, for: .normal)
            state = 1
        } else{
            //CheckBoxButton.setBackgroundImage(, for: .normal)
            state = 0
        }
    
    }
}

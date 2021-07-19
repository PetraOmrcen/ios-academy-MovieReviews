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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        LoginButton.layer.cornerRadius = 15.0
        
    }
    
    @IBAction private func CheckBoxButtonAction(_ sender: Any) {
        
        
    }
    
    
}

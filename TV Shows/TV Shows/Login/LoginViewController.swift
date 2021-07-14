//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 14.07.2021..
//

import UIKit

class LoginViewController: UIViewController {
    
    private var counter = 0

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // adding round corners to button
        button.layer.cornerRadius = 25.0
    }
    
    @IBAction private func buttonActionHandler(_ sender: Any) {
        print("Button pressed")
        counter += 1
        titleLabel.text = String(counter)
        if activityIndicator.isAnimating {
            
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        
        }
    }
}

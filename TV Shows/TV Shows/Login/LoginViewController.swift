//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 14.07.2021..
//

import UIKit

class LoginViewController: UIViewController {
    
    var counter = 0

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding round corners to button
        button.layer.cornerRadius = 25.0
        
        //second case for activity indicator
        //activityIndicator.startAnimating()
        
    
    }
    @IBAction func buttonActionHandler(_ sender: Any) {
        print("Button pressed")
        
        counter += 1
        self.titleLabel.text = String(counter)
        
        //first case
        if activityIndicator.isAnimating {
            
            activityIndicator.stopAnimating()
        }else{
            activityIndicator.startAnimating()
        
        }
        
       
        
    
        
    
    
}
}

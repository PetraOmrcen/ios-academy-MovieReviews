//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 14.07.2021..
//

import UIKit
import SVProgressHUD
import Alamofire

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
    
    @IBAction func LoginButtonAction(_ sender: Any) {
           let storyboard = UIStoryboard(name: "Home", bundle: nil)
           let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "ViewController_Home")
           navigationController?.pushViewController(viewControllerHome, animated: true)
    }
    
    
    @IBAction func RegisterButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "ViewController_Home")
        navigationController?.pushViewController(viewControllerHome, animated: true)
    }
    
    
}

private extension LoginViewController {

    func alamofireCodableRegisterUserWith(email: String, password: String) {
        SVProgressHUD.show()

        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]

        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                switch dataResponse.result {
                case .success(let user):
                    self?._infoLabel.text = "Success: \(user)"
                    SVProgressHUD.showSuccess(withStatus: "Success")
                case .failure(let error):
                    self?._infoLabel.text = "API/Serialization failure: \(error)"
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }

}

// MARK: - Login + automatic JSON parsing

private extension LoginViewController {

    func loginUserWith(email: String, password: String) {
        SVProgressHUD.show()

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                switch dataResponse.result {
                case .success(let userResponse):
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    self?.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                case .failure(let error):
                    self?._infoLabel.text = "API/Serialization failure: \(error)"
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }

    // Headers will be used for subsequent authorization on next requests
    func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            _infoLabel.text = "Missing headers"
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        _infoLabel.text = "User: \(user), authInfo: \(authInfo)"
        SVProgressHUD.showSuccess(withStatus: "Success")
    }

}

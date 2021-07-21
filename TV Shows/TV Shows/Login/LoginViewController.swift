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
    
    private var JSONdata: [String: Any] = [:]
    private var AutfInfo: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginButton.layer.cornerRadius = 15.0
        
    }
    
}

// MARK: Register
private extension LoginViewController {

    @IBAction func RegisterButtonAction(_ sender: Any) {
    // func alamofireCodableRegisterUserWith(email: String, password: String) {
        SVProgressHUD.show()

        // check if strings exist
        if (EmailTextField.text?.isEmpty) == nil{
            EmailTextField.text = "Nothing writen"
        }
        if (PasswordTextField.text?.isEmpty) == nil{
            PasswordTextField.text = "Nothing writen"
        }
        // bez ovog ne radi....
        let email_text: String = EmailTextField.text!
        let password_text: String = PasswordTextField.text!
        
        // setting parameters
        let parameters: [String: String] = [
            "email": email_text,
            "password": password_text,
            "password_confirmation": password_text
        ]

        // Api request
        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse1.self) { [weak self] response in
                switch response.result {
                case .success(let userResponse):
                    print(userResponse.user.email)
                    print(userResponse.user.id)
                    print(userResponse.user.imageUrl)
                    let headers = response.response?.headers.dictionary ?? [:]
                    self?.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                    SVProgressHUD.dismiss()
                case .failure(let error):
                    print("Error")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "ViewController_Home")
        navigationController?.pushViewController(viewControllerHome, animated: true)
    }

}

// MARK: Login

private extension LoginViewController {

    @IBAction func LoginButtonAction(_ sender: Any) {
        SVProgressHUD.show()
        
        // check if strings exist
        if (EmailTextField.text?.isEmpty) == nil{
            EmailTextField.text = "Nothing writen"
        }
        if (PasswordTextField.text?.isEmpty) == nil{
            PasswordTextField.text = "Nothing writen"
        }
        // bez ovog ne radi....
        let email_text: String = EmailTextField.text!
        let password_text: String = PasswordTextField.text!

        let parameters: [String: String] = [
            "email": email_text,
            "password": password_text
        ]

        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            
            .validate()
            .responseDecodable(of: UserResponse1.self) { [weak self] response in
                switch response.result {
                case .success(let userResponse):
                    print(userResponse.user.email)
                    print(userResponse.user.id)
                    print(userResponse.user.imageUrl)
                    
                    self?.JSONdata["Email"] = userResponse.user.email
                    self?.JSONdata["Id"] = userResponse.user.id
                    self?.JSONdata["ImageUrl"] = userResponse.user.imageUrl

                    let headers = response.response?.headers.dictionary ?? [:]
                    self?.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                    SVProgressHUD.dismiss()
                case .failure(let error):
                    print("Error")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "ViewController_Home")
        navigationController?.pushViewController(viewControllerHome, animated: true)
    }
    

    func handleSuccesfulLogin(for user: User1, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        AutfInfo["User"] = user
        AutfInfo["authInfo"] = authInfo
        print(AutfInfo["User"], AutfInfo["authInfo"])
    }

}

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
    
    // MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    
    private var userResponse: UserResponse?
    private var authInfo: AuthInfo?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 15.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

    // MARK: - Register

private extension LoginViewController {

    @IBAction func registerButtonAction(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password]
        SVProgressHUD.show()
        loginRegisterRequest(parameters: parameters, code: "users")
    }
}

    // MARK: - Login

private extension LoginViewController {

    @IBAction func loginButtonAction(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else {
            return
        }

        let parameters: [String: String] = [
            "email": email,
            "password": password]
        SVProgressHUD.show()
        loginRegisterRequest(parameters: parameters, code: "users/sign_in")
    }

    // MARK: - Private functions -
    
    private func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        self.authInfo = authInfo
    }
    
    private func loginRegisterRequest(parameters: [String: String], code: String){
        AF
            .request(
                "https://tv-shows.infinum.academy/\(code)",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let userResponse):
                    self.userResponse = userResponse
                    let headers = response.response?.headers.dictionary ?? [:]
                    self.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                    SVProgressHUD.dismiss()
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let viewControllerHome = storyboard.instantiateViewController(withIdentifier: "ViewController_Home")
                    self.navigationController?.pushViewController(viewControllerHome, animated: true)
                case .failure(let error):
                    print("Error: \(error)")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }

}

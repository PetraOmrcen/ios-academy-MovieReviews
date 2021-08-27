//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 14.07.2021..
//

import UIKit
import SVProgressHUD
import Alamofire
import Locksmith

class LoginViewController: UIViewController {
        
    // MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var eyeButton: UIButton!
    
    // MARK: - Properties
    
    private var userResponse: UserResponse?
    private var authInfo: AuthInfo?
    private var rememberMe: Bool = false
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.textColor = .white
        passwordTextField.textColor = .white
        loginButton.layer.cornerRadius = 15.0
        eyeButton.setImage(UIImage(named: "closed_eye"), for: .normal)
        rememberMeButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
        rememberMeButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .selected)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                emailTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: attributes)
                passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: attributes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        UIView.animate(withDuration: 0.5,
                       delay: 0.4,
                       options: [],
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
          }, completion: nil)
    }
    
    // MARK: -Actions
    
    @IBAction func hideShowPasswordAction(_ sender: Any) {
            passwordTextField.isSecureTextEntry.toggle()
            let imageName = passwordTextField.isSecureTextEntry ? "closed_eye" : "open_eye"
            eyeButton.setImage(UIImage(named: imageName), for: .normal)
        }
}


    // MARK: - Register

private extension LoginViewController {

    @IBAction func registerButtonAction(_ sender: Any) {
        animationBounce(sender: sender)
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
    
    @IBAction func rememberMeButtonTapped(_ sender: Any) {
        if rememberMeButton.currentImage == UIImage(named: "ic-checkbox-unselected") {
            rememberMe = true
        }
        rememberMeButton.isSelected.toggle()
    }
}

    // MARK: - Login

private extension LoginViewController {

    @IBAction func loginButtonAction(_ sender: Any) {
        animationScale(sender: sender)
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
}

    // MARK: - Private functions -

private extension LoginViewController {
    
    func loginRegisterRequest(parameters: [String: String], code: String) {
        
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
                    guard let vc = viewControllerHome as? HomeViewController else { return }
                    vc.authInfo = self.authInfo
                    vc.userResponse = self.userResponse

                    if self.rememberMe {
                        self.saveAuthInfoToUserDefaults()
                    }
                    self.navigationController?.pushViewController(viewControllerHome, animated: true)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    self.errorAlert(error: error)
                }
            }
    
    }
    
    func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        return self.authInfo = authInfo
    }
    
    func errorAlert(error: Error) {
        let alert = UIAlertController(title: "Error acured", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func saveAuthInfoToUserDefaults() {
        guard let encoded = try? JSONEncoder().encode(authInfo) else { return }
        
        UserDefaults.standard.set(encoded, forKey: UserDefaultKeys.authInfo.rawValue)
    }
    
}

// MARK: - Animations

private extension LoginViewController {
    
    func animationScale(sender: Any){
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 2.0
        pulseAnimation.fromValue = 0.0
        pulseAnimation.toValue = 1.0
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 1
        (sender as AnyObject).layer.add(pulseAnimation, forKey: nil)
    }
    
    func animationBounce(sender: Any){
        let springAnimationWidth = CASpringAnimation(keyPath: "bounds.size.width")
        springAnimationWidth.fromValue = (sender as AnyObject).layer.bounds.size.width
        springAnimationWidth.toValue = 10
        springAnimationWidth.damping = 0.75
        
        let springAnimationHeight = CASpringAnimation(keyPath: "bounds.size.height")
        springAnimationHeight.fromValue = (sender as AnyObject).layer.bounds.size.height
        springAnimationHeight.toValue = 10
        springAnimationHeight.damping = 0.75
        
        let group = CAAnimationGroup()
        group.duration = 2.0
        group.repeatCount = 1
        group.animations = [springAnimationWidth, springAnimationHeight]
        
        (sender as AnyObject).layer.add(group, forKey: "bouncebounce")
    }
}

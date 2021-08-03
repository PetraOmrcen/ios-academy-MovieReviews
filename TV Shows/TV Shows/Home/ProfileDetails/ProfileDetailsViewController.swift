//
//  ProfileDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 02.08.2021..
//

import UIKit
import SVProgressHUD
import Alamofire
import Kingfisher

class ProfileDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Private UI
    
    @IBOutlet private weak var profilePictureImage: UIImageView!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    
    // MARK: - Properties
    
    var authInfo: AuthInfo!
    var user: User?
    let imagePicker = UIImagePickerController()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileDetails()
        imagePicker.delegate = self
        logoutButton.layer.cornerRadius = 23.0
        navigationItem.title = "My account"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
          )
    }
    
    // MARK: - Actions
    
    @IBAction func logoutAction(_ sender: Any) {
        dismiss(animated: true, completion: {
            UserDefaults.standard.removeObject(forKey: UserDefaultKeys.authInfo.rawValue)
            NotificationCenter.default.post(name: .didLogout, object: nil)
            })
    }
    
    @IBAction func changeProfilePictureAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - Private func
    
    @objc private func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setDetails()
    {
        self.emailLabel.text = user?.email
        profilePictureImage.kf.setImage(
            with: user?.imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder")
           )
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePictureImage.contentMode = .scaleAspectFit
            profilePictureImage.image = pickedImage
            guard let profileImage = profilePictureImage.image else { return }
            storeImage(profileImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
   func storeImage(_ image: UIImage) {
       guard
           let imageData = image.jpegData(compressionQuality: 0.9)
       else { return }
       let requestData = MultipartFormData()
       requestData.append(
           imageData,
           withName: "image",
           fileName: "image.jpg",
           mimeType: "image/jpg")
        
    AF
    .upload(
        multipartFormData: requestData,
        to: "https://tv-shows.infinum.academy/users",
        method: .put,
        headers: HTTPHeaders(self.authInfo.headers)
    )
    .validate()
    .responseDecodable(of: UserResponse.self) { response in
        print(response)
        switch response.result {
        case .success(let userResponse):
            self.user = userResponse.user
        case .failure(let error):
            SVProgressHUD.showError(withStatus: "Failure picture upload")
            print(error)
        }
    }
   }
}

private extension ProfileDetailsViewController {
    
        func getProfileDetails() {
           AF
            .request(
                "https://tv-shows.infinum.academy/users/me",
                method: .get,
            headers: HTTPHeaders(self.authInfo.headers)
             )
             .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let userResponse):
                    self.user = userResponse.user
                    self.setDetails()
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Failure user details fetching")
                    print(error)
                }
             }
        }
}



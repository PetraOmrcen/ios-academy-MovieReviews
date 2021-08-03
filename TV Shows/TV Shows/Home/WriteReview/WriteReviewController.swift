//
//  WriteReviewController.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import SVProgressHUD
import Alamofire

class WriteReviewController: UIViewController {
    
    // MARK: - Private UI
    
    @IBOutlet private var ratingView: RatingView!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private var submitButton: UIButton!
    
    // MARK: - Properties
    
    var authInfo: AuthInfo!
    var showId: String = ""
    var rating: Int?
    weak var delegate: ReviewAddedDelegate?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Write a review"
        submitButton.layer.cornerRadius = 23.0
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
          )
    }

    // MARK: - Private func
    
    @objc private func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions
    
    @IBAction func submitButtonAction(_ sender: Any) {
        let rating = "\(ratingView.rating)"
        guard let comment = commentTextView.text else {return}
        let parameters: [String: String] = [
            "rating": rating,
            "comment": comment,
            "show_id": showId]
        
        SVProgressHUD.show()
        writeReviewRegisterRequest(parameters: parameters)
        commentTextView.text = ""
        ratingView.rating = 0
    }
}

// MARK: - Private

private extension WriteReviewController {

    func writeReviewRegisterRequest(parameters: [String: String]) {
        AF
            .request(
                "https://tv-shows.infinum.academy/reviews",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default,
                headers: HTTPHeaders(self.authInfo.headers)
            )
            .validate()
            .responseDecodable(of: NewReviewResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let newReviewResponse):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    SVProgressHUD.dismiss()
                    self.delegate?.didAddReview(review: newReviewResponse.review)
                    print(newReviewResponse.review as Any)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    self.errorAlert(error: error)
                }
            }
    }
    
    func errorAlert(error: Error) {
        let alert = UIAlertController(title: "Error acured", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

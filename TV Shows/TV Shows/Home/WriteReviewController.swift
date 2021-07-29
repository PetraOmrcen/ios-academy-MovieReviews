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
    
    var authInfo: AuthInfo!
    var showId: String = ""
    var rating: Int = 1
    var newReview: Review?
    
    @IBOutlet private var ratingView: RatingView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet private var submitButton: UIButton!
    
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
        rating = 5
    }

    @objc private func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func submitButtonAction(_ sender: Any) {
        let rating = "\(ratingView.rating)"
        guard let comment = commentTextView.text else {return}
        let parameters: [String: String] = [
            "rating": rating,
            "comment": comment,
            "show_id": showId]
        
        SVProgressHUD.show()
        writeReviewRegisterRequest(parameters: parameters)
    }
}

private extension WriteReviewController {

    private func writeReviewRegisterRequest(parameters: [String: String]){
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
                    self.newReview = newReviewResponse.review
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    SVProgressHUD.dismiss()
                    print(self.newReview)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    self.errorAlert(error: error)
                }
            }
    }

    private func errorAlert(error: Error){
        let alert = UIAlertController(title: "Error acured", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

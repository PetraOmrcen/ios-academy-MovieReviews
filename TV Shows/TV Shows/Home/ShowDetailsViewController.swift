//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import SVProgressHUD
import Alamofire

class ShowDetailsViewController: UIViewController {
    
    // MARK: - Private UI
    
    @IBOutlet private weak var writeReviewButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var authInfo: AuthInfo!
    var showId: String = ""
    var showData: Show!
    var reviews: [Review] = []
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeReviewButton.layer.cornerRadius = 23.0
        displayShowRequest()
        setupTableView()
    }
    
    // MARK: - Actions
    
    @IBAction func writeReviewAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let writeReviewController = storyboard.instantiateViewController(withIdentifier: "ViewController_WriteReview")
        let navigationController = UINavigationController(rootViewController:
        writeReviewController)
        guard let vc = writeReviewController as? WriteReviewController else { return }
        vc.authInfo = authInfo
        vc.showId = showId
        present(navigationController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ShowDetailsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ShowDetailsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(
            withIdentifier: "MovieDetailsTableViewCell",
            for: indexPath) as! MovieDetailsTableViewCell
        
        let cell2 = tableView.dequeueReusableCell(
            withIdentifier: "MovieReviewTableViewCell",
            for: indexPath) as!
            MovieReviewTableViewCell
        
        if indexPath.row == 0{
            cell1.titleLabel.text = showData.title
            cell1.decriptionLabel.text = showData.description
            cell1.reviwAndRatingLabel.text = "\(reviews.count) REVIEWS, \(showData.averageRating) AVERAGE"
            return cell1
        } else{
            cell2.ratingView.setRoundedRating(Double(reviews[indexPath.row-1].rating))
            cell2.emailLabel.text = reviews[indexPath.row-1].user.email
            cell2.reviewLabel.text = reviews[indexPath.row-1].comment
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count + 1
    }
}

// MARK: - Private

private extension ShowDetailsViewController {

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

private extension ShowDetailsViewController{
    
    private func displayShowRequest(){
       AF
        .request(
            "https://tv-shows.infinum.academy/shows/\(self.showId)/reviews",
             method: .get,
        headers: HTTPHeaders(self.authInfo.headers)
         )
         .validate()
        .responseDecodable(of: ReviewsResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let reviewsResponse):
                self.reviews = reviewsResponse.reviews
                self.tableView.reloadData()
                SVProgressHUD.showSuccess(withStatus: "Success")
                SVProgressHUD.dismiss()
            case .failure(let error):
                SVProgressHUD.showError(withStatus: "Failure shows")
                print(error)
            }
         }
    
    }
}

protocol ReviewAddedDelegate: AnyObject {
    func didAddReview(review: Review)
}

extension ShowDetailsViewController: ReviewAddedDelegate{
    func didAddReview(review: Review) {
        reviews.append(review)
        tableView.reloadData()
    }
}

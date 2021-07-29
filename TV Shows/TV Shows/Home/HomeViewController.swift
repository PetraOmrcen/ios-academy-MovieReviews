//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 20.07.2021..
//

import UIKit
import SVProgressHUD
import Alamofire

class HomeViewController: UIViewController {
    
    // MARK: - Private UI
    
    @IBOutlet private weak var tableView: UITableView!

    
    // MARK: - Properties
    
    var userResponse: UserResponse!
    var authInfo: AuthInfo!
    var shows: [Show] = []
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        showListsRequest()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
}
    
    // MARK:  - Private functions -

private extension HomeViewController{
    private func showListsRequest(){
       AF
        .request(
             "https://tv-shows.infinum.academy/shows",
             method: .get,
             parameters: ["page": "1", "items": "100"], // pagination arguments
        headers: HTTPHeaders(self.authInfo.headers)
         )
         .validate()
        .responseDecodable(of: ShowsResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let showsResponse):
                self.shows = showsResponse.shows
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

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TVShowTableViewCell",
            for: indexPath
        ) as! TVShowTableViewCell
        
        cell.showNameLabel.text = shows[indexPath.row].title
        return cell
    }
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        // Push ShowDetailsViewController
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerShowDetails = storyboard.instantiateViewController(withIdentifier: "ViewController_ShowDetails")
        guard let vc = viewControllerShowDetails as? ShowDetailsViewController else { return }
        vc.authInfo = self.authInfo
        vc.showId = shows[indexPath.row].id
        vc.showData = shows[indexPath.row]
        self.navigationController?.pushViewController(viewControllerShowDetails, animated: true)
    }
}

// MARK: - Private

private extension HomeViewController {
     func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

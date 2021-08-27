//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 20.07.2021..

import UIKit
import SVProgressHUD
import Alamofire

class HomeViewController: UIViewController{
    
    // MARK: - Private UI
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var notificationToken: NSObjectProtocol?
    var userResponse: UserResponse!
    var authInfo: AuthInfo!
    private var shows: [Show] = []
    private var limit = 20
    private var totalEntries = 100
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        showListsRequest(page: "1",items: "20")
        setupTableView()
        
        let profileDetailsItem = UIBarButtonItem(
                  image: UIImage(named: "ic-profile"),
                  style: .plain,
                  target: self,
                  action: #selector(profileDetailsActionHandler))
        profileDetailsItem.tintColor = UIColor.purple
        navigationItem.rightBarButtonItem = profileDetailsItem
        
        //Notifikacija za logout
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogout(_:)), name: .didLogout, object: nil)
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}
    
    // MARK:  - Private functions

private extension HomeViewController {
    func showListsRequest(page: String, items: String) {
       AF
        .request(
             "https://tv-shows.infinum.academy/shows",
             method: .get,
             parameters: ["page": page, "items": items], // pagination arguments
        headers: HTTPHeaders(self.authInfo.headers)
         )
         .validate()
        .responseDecodable(of: ShowsResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let showsResponse):
                self.shows.append(contentsOf: showsResponse.shows)
                self.tableView.reloadData() //ovo mozda ne ide tu
                SVProgressHUD.showSuccess(withStatus: "Success")
                SVProgressHUD.dismiss()
            case .failure(let error):
                SVProgressHUD.showError(withStatus: "Failure shows")
                print(error)
            }
         }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TVShowTableViewCell",
            for: indexPath
        ) as! TVShowTableViewCell
        cell.configure(with: shows[indexPath.row])
        return cell
    }
    
    // adding new shows
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == shows.count - 1 {
            // we are at the last cell, load more content
            if shows.count < totalEntries {
                // provjeri jos
                showListsRequest(page: String(indexPath.row), items: "20")
                self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
            }
        }
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
        vc.show = shows[indexPath.row]
        self.navigationController?.pushViewController(viewControllerShowDetails, animated: true)
    }
}

// MARK: - Private

private extension HomeViewController {
     func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc
    func profileDetailsActionHandler() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let profileDetailsController = storyboard.instantiateViewController(withIdentifier: "ViewController_ProfileDetails")
        let navigationController = UINavigationController(rootViewController:
        profileDetailsController)
        guard let vc = profileDetailsController as? ProfileDetailsViewController else { return }
        vc.authInfo = authInfo
        present(navigationController, animated: true)
    }
    
    @objc
    func onDidLogout(_ notification: Notification) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewControllerLogin = storyboard.instantiateViewController(withIdentifier: "ViewController_Login")
        navigationController?.setViewControllers([viewControllerLogin], animated: true)
    }
    
    @objc
    func loadTable(){
        self.tableView.reloadData()
    }
}

extension Notification.Name {
    static let didLogout = Notification.Name("didLogout")
}

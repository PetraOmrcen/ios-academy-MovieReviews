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
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    var showResponse: ShowsResponse?
    var showsArray: [Show]?
    var count: Int?
    
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
        //probala sam i ovako, ali nije radilo: navigationController?.setViewControllers([homeViewController], animated: true)
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
        headers: HTTPHeaders(self.authInfo!.headers)
         )
         .validate()
        .responseDecodable(of: ShowsResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let showsResponse):
                self.showResponse = showsResponse
                self.showsArray = showsResponse.shows
                guard
                    let count = self.showsArray?.count
                else {
                    return
                }
                self.count = count
                print("broj serija:", self.count)
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
    //tableView.reloadData() //beacuse of api calls
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Default implementation - if not implemented would return 1 as well
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("self.count u tableview", self.count)
        return self.showResponse?.shows.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TVShowTableViewCell",
            for: indexPath
        ) as! TVShowTableViewCell
        
        //zasto toliko problema svaki put??????????????????
        cell.showNameLabel.text = self.showResponse?.shows[indexPath.row].title
//        let show = String(self.showResponse?.shows[indexPath.row].title))
//        cell.configure(with: show)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = self.showResponse?.shows[indexPath.row].title
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerShowDetails = storyboard.instantiateViewController(withIdentifier: "ViewController_ShowDetails")
        self.navigationController?.pushViewController(viewControllerShowDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 20 {
            //something
            tableView.reloadData()
        }
    }
}

// MARK: - Private

private extension HomeViewController {

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

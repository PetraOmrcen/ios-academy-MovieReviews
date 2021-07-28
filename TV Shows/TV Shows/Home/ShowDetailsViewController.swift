//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var writeReviewButton: UIButton!
    
    @IBAction func writeReviewAction(_ sender: Any) {
        print("Stisnuto")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let writeReviewController = storyboard.instantiateViewController(withIdentifier: "ViewController_WriteReview")
        let navigationController = UINavigationController(rootViewController:
        writeReviewController)
        present(navigationController, animated: true)
        print("Stisnuto 2")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

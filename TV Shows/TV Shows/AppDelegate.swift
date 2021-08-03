//
//  AppDelegate.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let authInfo: AuthInfo? = retrieveAuthInfoFromUserDefaults()
        
        // Check if user picked remember
        if let authInfo = authInfo,
            let homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ViewController_Home") as? HomeViewController
           {
            homeViewController.authInfo = authInfo
            navigationController.viewControllers = [homeViewController]
        } else {
            let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "ViewController_Login")
            navigationController.viewControllers = [loginViewController]
        }
        
        // Set the navigation controller as starting point of the app
        guard let window = window else { return false }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return true
    }
    
    func retrieveAuthInfoFromUserDefaults() -> AuthInfo? {
        guard
            let data = UserDefaults.standard.object(forKey: UserDefaultKeys.authInfo.rawValue) as? Data,
            let authInfo = try? JSONDecoder().decode(AuthInfo.self, from: data)
        else { return nil }
        
        return authInfo
    }
    
}


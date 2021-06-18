//
//  AppDelegate.swift
//  Lec19HWFilters
//
//  Created by badyi on 16.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        let view = PhotoView()
        let controller = PhotoViewController(with: view)
        view.controller = controller
        navigationController.viewControllers = [controller]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}


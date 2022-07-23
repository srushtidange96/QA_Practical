//
//  AppDelegate.swift
//  Quantsapp
//
//  Created by Srushti Dange on 20/07/22.
//

import UIKit
import CoreData
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var AFManager = SessionManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120 // seconds
        configuration.timeoutIntervalForResource = 120 //seconds
        AFManager = Alamofire.SessionManager(configuration:configuration)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

}


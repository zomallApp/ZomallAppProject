//
//  AppDelegate.swift
//  ZomallApp
//
//  Created by Usman on 15/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        // Override point for customization after application launch.
       
        let defaults = UserDefaults.standard
        defaults.set("usmanirfan996@gmail.com", forKey: "email")
        defaults.set("Usman", forKey: "name")

       FirebaseApp.configure()
        let storyboard = UIStoryboard(name: "Main", bundle: nil) //Write your storyboard name
                let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController")
                self.window.rootViewController = viewController
                self.window.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


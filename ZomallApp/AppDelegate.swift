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
        self.loginApiCall()
        let defaults = UserDefaults.standard
        defaults.set("usmanirfan996@gmail.com", forKey: "email")
        defaults.set("Usman", forKey: "name")

       FirebaseApp.configure()
       
        return true
    }
    
     func loginApiCall() {
           let url = URL(string:"https://sayingz.com/api/webemaillogin")
                  
                  guard let requestUrl = url else { fatalError() }

                  // Prepare URL Request Object
                  var request = URLRequest(url: requestUrl)
                  request.httpMethod = "POST"
                   
                  // HTTP Request Parameters which will be sent in HTTP Request Body
                  let postString = "email=iamahmerr@gmail.com&password=12345678"

                  // Set HTTP Request Body
                  request.httpBody = postString.data(using: String.Encoding.utf8)

                  // Perform HTTP Request
                  let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                          
                          // Check for Error
                          if let error = error {
                              print("Error took place \(error)")
                              return
                          }
                          // Convert HTTP Response Data to a String
                          if let data = data, let dataString = String(data: data, encoding: .utf8) {
                              print("Response data string:\n \(dataString)")
                           
                                          do {
                                              let decoder = JSONDecoder()
                                              let result = try decoder.decode(LoginResponseModel.self, from: data)
                                           self.loginAPIResult(result: result)
                                              
                                          } catch let error {
                                              print(error.localizedDescription)
                                             
                                          }
                                      }
                          }
           task.resume()
       }
       
       func loginAPIResult(result : LoginResponseModel) {
        
        print(result.peoples?.gender)
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


//
//  ApiManager.swift
//  ZomallApp
//
//  Created by Baskt QA on 22/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager {
//    private static var sharedGlobalRecources: ApiManager = {
//
//         var alamoFireManager : SessionManager?
//           let GR = ApiManager()
//
//           // Configuration
//           // ...
//           let configuration = URLSessionConfiguration.default
//
//           configuration.timeoutIntervalForRequest = 60*5
//
//           configuration.timeoutIntervalForResource = 60*5
//           GR.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
//           GR.SocketHandler()
//           return GR
//       }()
       
       // MARK: - Accessors
       
//       class func shared() -> ApiManager {
//           
//           return sharedGlobalRecources
//       }
    
    
    // check kr isko
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
                       }
               }
               task.resume()


    }
    
}

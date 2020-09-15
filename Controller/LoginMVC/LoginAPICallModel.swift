//
//  LoginAPICallModel.swift
//  ZomallApp
//
//  Created by Baskt QA on 15/09/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation
import UIKit

struct LoginAPICallModel {
    weak var delegate: loginAPIResultDelegate?
    init() {}
}

extension LoginAPICallModel {
  func loginApiCall(credential email:String, password: String) {
        let url = URL(string:"https://sayingz.com/api/webemaillogin")
               
               guard let requestUrl = url else { fatalError() }

               // Prepare URL Request Object
               var request = URLRequest(url: requestUrl)
               request.httpMethod = "POST"
                
               // HTTP Request Parameters which will be sent in HTTP Request Body
               let postString = "email=\(email)&password=\(password)"

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
        self.delegate?.loginAPIResult(status: result.status ?? "", result: result)
    }
    
}

protocol loginAPIResultDelegate: AnyObject {
    func loginAPIResult(status: String, result: LoginResponseModel)
}

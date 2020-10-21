//
//  SignUpAPICallModel.swift
//  ZomallApp
//
//  Created by Baskt QA on 15/09/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation

struct SignupAPICallModel {
    weak var delegate: SignupAPIResultDelegate?
    init() {}
    
}
extension SignupAPICallModel {
    func signupApiCall(credential email:String, password: String, name: String, gender: String, dob:String, country:String, age: Int, info: String, image: String, interests: String) {
        let url = URL(string:"https://sayingz.com/api/signup")
               
               guard let requestUrl = url else { fatalError() }

               // Prepare URL Request Object
               var request = URLRequest(url: requestUrl)
               request.httpMethod = "POST"
                
               // HTTP Request Parameters which will be sent in HTTP Request Body
               let postString = "email=\(email)&password=\(password)&id==123456&type=email&name=\(name)&gender=\(gender)&device_id=12346543&dob=\(dob)&country=\(country)&age=\(age)&info=\(info)&images=\(image)&check=\(interests)"

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
                                           let result = try decoder.decode(SignupResponseModel.self, from: data)
                                        self.SignupAPIResult(result: result)
                                           
                                       } catch let error {
                                           print(error.localizedDescription)
                                          
                                       }
                                   }
                       }
        task.resume()
    }
    
    func SignupAPIResult(result : SignupResponseModel) {
        
        self.delegate?.signUpAPIResult(status: result.status ?? "Undefined" , result: result)
    }
    
}

protocol SignupAPIResultDelegate: AnyObject {
    func signUpAPIResult(status: String, result: SignupResponseModel)
}

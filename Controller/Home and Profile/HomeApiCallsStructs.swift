//
//  HomeApiCallsStructs.swift
//  ZomallApp
//
//  Created by Baskt QA on 20/10/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation

struct HomeApiCallsStructs {
     weak var delegate: HomeAPICallResponseDelegate?
       init() {}
}

extension HomeApiCallsStructs {
    
    func getPeople(userId: String, limit: Int) {
        
        let url = URL(string:"https://sayingz.com/api/getpeople")
                      
                      guard let requestUrl = url else { fatalError() }

                      // Prepare URL Request Object
                      var request = URLRequest(url: requestUrl)
                      request.httpMethod = "POST"
                       
                      // HTTP Request Parameters which will be sent in HTTP Request Body
                      let postString = "user_id=\(userId)&limit=\(limit)"

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
                                                  let result = try decoder.decode(GetPeopleForSwipes.self, from: data)
                                               self.getSwipesResults(result: result)
                                                  
                                              } catch let error {
                                                  print(error.localizedDescription)
                                                 
                                              }
                                          }
                              }
               task.resume()
        
    }
    
    func getSwipesResults(result: GetPeopleForSwipes){
        self.delegate?.getPeopleApi(apiStatus: result.status ?? "No Status", result: result.userData ?? [])
    }
    
}

protocol HomeAPICallResponseDelegate: AnyObject {
    func getPeopleApi(apiStatus: String, result: [UserInfo])
}

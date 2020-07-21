//
//  MessageVC.swift
//  ZomallApp
//
//  Created by Usman on 17/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit


class MessageVC: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var messages: [Message] = [
    Message(name: "Usman", message: "Hello how are you"),
    Message(name: "Ahmer", message: "I'mhchc sbccb  bx bccbcbbcbsc c saBCbcbsabcbsachaBCHHC HSCa ccb   sha csa c fine.hehhdh Thank You!"),
    Message(name: "Ayesha", message: "Hello how are you"),
    Message(name: "Umer", message: "Hello how are you"),
    Message(name: "Abdullah", message: "Hello how are you"),
    Message(name: "Fatima", message: "Hello how are you"),
    Message(name: "Peter", message: "Hello how are you"),
    Message(name: "Hande", message: "Hello how are you"),


    ]

    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white

        self.navigationItem.title = "Messages";
        
        messageTableView.dataSource = self
        messageTableView.delegate = self

        messageTableView.register(UINib(nibName: "MessageCellTableViewCell", bundle: nil ), forCellReuseIdentifier: "reusableCell")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! MessageCellTableViewCell
        cell.name.text = messages[indexPath.row].name
        cell.body.text = messages[indexPath.row].message

        return cell
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
         return 80 // custom height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  let vc = ChatVC()
//        vc.title = "Usman"
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

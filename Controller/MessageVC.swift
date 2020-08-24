//
//  MessageVC.swift
//  ZomallApp
//
//  Created by Usman on 17/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit


class MessageVC: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var noConversationsLabel: UILabel!
    var messages = [chats]()
    var conversations = [Conversations]()
    // get this through API
    public var otherUserName: String = "Ayesha"
    
    @IBAction func newPressed(_ sender: Any) {
        let vc = ChatVC(with: "ayesha23gmailcom",otherUserName: otherUserName,id:"",isNewConversation: true)
        vc.title = otherUserName
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.loadConversations()
        messageTableView.isHidden = true
        noConversationsLabel.isHidden = true
        
    }
    
    
    
    
    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationItem.title = "Messages";
        self.loadConversations()
        messageTableView.dataSource = self
        messageTableView.delegate = self
        
        messageTableView.register(UINib(nibName: "MessageCellTableViewCell", bundle: nil ), forCellReuseIdentifier: "reusableCell")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       

        return conversations.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! MessageCellTableViewCell
        let model = conversations[indexPath.row]
        if model.latest_message.is_read == false{
            cell.body.font = UIFont.boldSystemFont(ofSize: 13.0)
            cell.body.textColor = .black
        }
        cell.name.text = model.name
        print(model.name)
        cell.body.text = model.latest_message.text

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ChatVC(with: conversations[indexPath.row].otherUserEmail, otherUserName:  otherUserName, id:  conversations[indexPath.row].id, isNewConversation: false)
        
        vc.title = otherUserName
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    private func loadConversations(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
            return
        }
        let databaseEmail = FirebaseManager.shared.createEmailString(currentEmail: email)
        
        
        FirebaseManager.shared.getAllConversations(for: databaseEmail) { (result) in
            switch(result){
            case .success(let conversation):
                guard !conversation.isEmpty else{
                    self.messageTableView.isHidden = true
                    self.noConversationsLabel.isHidden = false
                    return
                }
                self.noConversationsLabel.isHidden = true
                self.messageTableView.isHidden = false
                self.conversations = conversation
                DispatchQueue.main.async {
                    self.messageTableView.reloadData()

                }
                
                
                
            case .failure(_):
                print("Hi")

                self.messageTableView.isHidden = true
                self.noConversationsLabel.isHidden = false

                break

            }
        }

        
        
    }
}

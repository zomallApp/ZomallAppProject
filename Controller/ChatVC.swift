////
////  ChatVC.swift
////  ZomallApp
////
////  Created by Usman on 18/07/2020.
////  Copyright © 2020 Usman. All rights reserved.
////
//
//import UIKit
//import MessageUI
//
//
//class ChatVC: MessagesViewController {
//
//    private var chat = [chats]()
//    private let selfSender = Sender(photoURL: "Me", senderId: "1", displayName: "Usman")
//    private let otherSender = Sender(photoURL: "Me", senderId: "2", displayName: "Ali")
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        chat.append(chats(
//            sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello! How are you! Hi")
//        ))
//        chat.append(chats(
//            sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello! How are you! Hi")
//        ))
//        chat.append(chats(
//            sender: otherSender, messageId: "2", sentDate: Date(), kind: .text("Hello! How are you! Hsah cxba achab chac b cb cbd cb c cb i")
//        ))
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
//
//        // Do any additional setup after loading the view.
//    }
//    
//    
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in  messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        let borderColor:UIColor = isFromCurrentSender(message: message) ? .clear: .clear
//        return .bubbleTailOutline(borderColor, corner, .curved)
//    }
//    
//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return (isFromCurrentSender(message: message) ? UIColor(named: "sender") ?? UIColor.blue  : UIColor(named: "reciever") ?? UIColor.gray)
//    }
//    
//        /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//extension ChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
//    
//    func currentSender() -> SenderType {
//        return selfSender
//    }
//    
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        return chat[indexPath.section]
//    }
//    
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        return chat.count
//    }
//    
//    
//}

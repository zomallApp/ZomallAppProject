//
//  FirebaseManager.swift
//  ZomallApp
//
//  Created by Usman on 25/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MessageKit
import FirebaseStorage

enum DatabaseError: Error {
    case badURL
    
}

public enum StorageErrors: Error {
    case failedToUpload
    case failedToGetDownloadUrl
    case NoConversations
}


class FirebaseManager {
    
    
    private let storageRef = Storage.storage().reference()
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    static let shared = FirebaseManager()
    var conversationList = [Conversations]()
    
    var ref = Database.database().reference()
    
     func createEmailString(currentEmail: String) -> String {
        let newString = currentEmail
        var safeString = newString.replacingOccurrences(of: "@", with: "")
        safeString = safeString.replacingOccurrences(of: "_", with: "")
        safeString = safeString.replacingOccurrences(of: ".", with: "")
        return safeString
    }
    public func createNewConversation(with otherUserEmail: String, firstMessage: chats, otherUserName: String, completion: @escaping (Bool)-> Void){
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") else{
            return
        }
        guard let senderName = UserDefaults.standard.value(forKey: "name") else{
            return
        }
        
        let email = createEmailString(currentEmail: currentEmail as! String)
        let otheremail = createEmailString(currentEmail: otherUserEmail as! String)
        
        let node = ref.child("\(email)")
        node.observeSingleEvent(of: .value) { (snapshot) in
            guard var userNode = snapshot.value as? [String:Any] else {
                return
            }
            
            
            var message = ""
            switch firstMessage.kind{
                
            case.text(let messageText):
                message = messageText
                break
            case .attributedText(_):
                break
            case.photo(_):
                break
            case.audio(_):
                break
                
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            case .linkPreview(_):
                break
            }
            
            let conversationID = "conversation_\(firstMessage.messageId)"
            let newConversationData: [String:Any] = [
                "id":conversationID,
                "other_user_email":otherUserEmail,
                "otherUserName": otherUserName,
                "latest_message":[
                    "date":self.changeDateFormat(date: firstMessage.sentDate),
                    "message_body": message,
                    "is_read": false
                    
                ]
                
            ]
            let newRecipientConversationData: [String:Any] = [
                "id":conversationID,
                "other_user_email":email,
                "otherUserName": senderName as? String,
                "latest_message":[
                    "date":self.changeDateFormat(date: firstMessage.sentDate),
                    "message_body": message,
                    "is_read": false
                    
                ]
                
            ]
            
            
            //Update for Recipient
            
            self.ref.child("\(otheremail)/conversations").observeSingleEvent(of: .value) {[weak self] (snapshot) in
                if var conversations = snapshot.value as? [[String:Any]]{
                    
                    conversations.append(newRecipientConversationData)
                    self?.ref.child("\(otheremail)/conversations").setValue(conversations)
                }else{
                    self?.ref.child("\(otheremail)/conversations").setValue([newRecipientConversationData])
                }
            }
            
            if var conversations = userNode["conversations"] as? [[String:Any]] {
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                node.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.CreateConversationBlock(conversationID: conversationID, firstMessage: firstMessage, otherUserName: otherUserName, completion: completion)
                    
                })
                
            } else{
                userNode["conversations"] = [
                    newConversationData
                ]
                node.setValue(userNode, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        
                        return
                    }
                    self.CreateConversationBlock(conversationID: conversationID, firstMessage: firstMessage, otherUserName: otherUserName, completion: completion)
                    
                    
                    
                })
            }
        }
        
        
        
    }
    
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversations],Error>)-> Void) {
        print(email)
        ref.child("\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String:Any]] else{
                completion(.failure(StorageErrors.NoConversations))
                return
            }
            let conversation: [Conversations] = value.compactMap ({ dictionary in
                guard let conversationID = dictionary["id"] as? String,
                    
                    let name = dictionary["otherUserName"] as? String,
                    let otherUserEmail = dictionary["other_user_email"] as? String,
                    
                    let latestMessage = dictionary["latest_message"] as? [String:Any],
                    let sent_date = latestMessage["date"] as? String,
                    let message = latestMessage["message_body"] as? String,
                    let isRead = latestMessage["is_read"] as? Bool else{
                        return nil
                }
                
                let latestMessageObj = LatestMessage(date: sent_date, text: message, is_read: isRead)
                
                print(latestMessageObj)
                return Conversations(id: conversationID, name: name, otherUserEmail: otherUserEmail, latest_message: latestMessageObj)
                
            })
            completion(.success(conversation))
            
        })
        
        
    }
    public func loadAllMessages(with id: String, completion: @escaping (Result<[chats],Error>)-> Void){
        ref.child("\(id)/messages").observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [[String:Any]] else{
                print("error fetching result")
                return
            }
            let messages: [chats] = value.compactMap ({ dictionary in
                guard let name = dictionary["otherUserName"] as? String,
                    let isRead = dictionary["is_read"] as? Bool,
                    let messageID = dictionary["id"] as? String,
                    let content = dictionary["content"] as? String,
                    let senderEmail = dictionary["sender_email"] as? String,
                    let type = dictionary["type"] as? String,
                    let dateString = dictionary["date"] as? String
                    else { 
                        return nil
                }
                let date = self.changeDateFormat(date: dateString)
                
                var kind: MessageKind?
                if type == "photo" {
                    // photo
                    guard let imageUrl = URL(string: content),
                        let placeHolder = UIImage(systemName: "plus") else {
                            return nil
                    }
                    let media = Media(url: imageUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .photo(media)
                } else if type == "audio"{
                    guard let targetURL =  URL(string: content) else{
                        return nil
                    }
                    let audio = Audio(url: targetURL, duration: 0, size: CGSize(width: 140, height: 40))
                    kind = .audio(audio)
                }
                    
                    
                else {
                    kind = .text(content)
                }
                
                guard let finalKind = kind else {
                    return nil
                }

                
                let sender = Sender(photoURL: "", senderId: senderEmail, displayName: name)
                
                return chats(messageId: messageID, sender: sender, sentDate: date, kind: finalKind )
                
            })
            completion(.success(messages))
            
        }
        
        
    }
    private func CreateConversationBlock(conversationID: String, firstMessage: chats, otherUserName: String, completion: @escaping (Bool)->Void){
        
        var chatType = ""
        switch firstMessage.kind{
            
        case.text(let messageText):
            chatType = messageText
            break
        case .attributedText(_):
            break
        case.photo(_):
            break
        case.audio(_):
            break
            
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        case .linkPreview(_):
            break
        }
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") else{
            return
        }
        let email = createEmailString(currentEmail: currentEmail as! String)
        
        let message: [String:Any] = [
            "id": firstMessage.messageId,
            "type":firstMessage.kind.messageType,
            "content": chatType,
            "otherUserName": otherUserName,
            "date": changeDateFormat(date: firstMessage.sentDate),
            "sender_email": email,
            "is_read": false
        ]
        let value: [String:Any] = [
            "messages":[message]
        ]
        ref.child("\(conversationID)").setValue(value) { (error, _) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    private func changeDateFormat(date: Date)-> String{
        let messageDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, d MM y"
        return dateFormatter.string(from: messageDate)
    }
    private func changeDateFormat(date: String)-> Date{
        let messageDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, d MM y"
        return dateFormatter.date(from: messageDate)!
    }
    
    
    public func sendMessage(to conversation: String,name:String,otherUserEmail:String, newMessage: chats, completion: @escaping (Bool)->Void){
        
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") else{
            completion(false)
            return
        }
        
        
        let email = self.createEmailString(currentEmail: currentEmail as! String)
        
        
        self.ref.child("\(conversation)/messages").observeSingleEvent(of: .value, with:{ [weak self] snapshot in
            
            guard let strongSelf = self else{
                return
            }
            
            
            guard var currentMessage = snapshot.value as? [[String:Any]] else{
                completion(false)
                return
            }
            let messageDate = newMessage.sentDate
            let dateString = self?.changeDateFormat(date: messageDate)
            
            var message = ""
            switch newMessage.kind{
                
            case.text(let messageText):
                message = messageText
                break
            case .attributedText(_):
                break
            case.photo(let mediaItem):
                if let targetURL = mediaItem.url?.absoluteString{
                    message = targetURL
                    
                }
                break
            case.audio(let audioItem):
           message = audioItem.url.absoluteString
                
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            case .linkPreview(_):
                break
            }
            
                        
            let newMessageEntry: [String:Any] = [
                "id": newMessage.messageId,
                "type":newMessage.kind.messageType,
                "content": message,
                "otherUserName": name,
                "date": dateString,
                "sender_email": email,
                "is_read": false
            ]
            
            
            
            currentMessage.append(newMessageEntry)
            strongSelf.ref.child("\(conversation)/messages").setValue(currentMessage) { error, _ in
                
                guard error == nil else{
                    completion(false)
                    return
                }
                strongSelf.ref.child("\(email)/conversations").observeSingleEvent(of: .value, with: {snapshot in
                    
                    guard var currentUserConversations = snapshot.value as? [[String:Any]] else{
                        completion(false)
                        return
                    }
                    var databaseEntryConversations = [[String: Any]]()
                    let updatedValue: [String:Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message_body": message
                    ]
                    
                    
                    
                    
                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
                        
                        var targetConv: [String:Any]?
                        var position = 0
                        for conversations in currentUserConversations{
                            if let currentId = conversations["id"] as? String, currentId == conversation{
                                targetConv = conversations
                                break
                            }
                            position += 1
                        }
                        
                        
                        if var targetConv = targetConv {
                            targetConv["latest_message"] = updatedValue
                            currentUserConversations[position] = targetConv
                            databaseEntryConversations = currentUserConversations
                        }else {
                            let newConversationData: [String: Any] = [
                                "id": conversation,
                                "other_user_email": otherUserEmail,
                                "name": name,
                                "latest_message": updatedValue
                            ]
                            currentUserConversations.append(newConversationData)
                            databaseEntryConversations = currentUserConversations
                        }
                    }
                        
                        
                    else {
                        let newConversationData: [String: Any] = [
                            "id": conversation,
                            "other_user_email":otherUserEmail,
                            "name": name,
                            "latest_message": updatedValue
                        ]
                        databaseEntryConversations = [
                            newConversationData
                        ]
                    }
                    
                    strongSelf.ref.child("\(email)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        
                        
                        //update for recipient
                        
                        strongSelf.ref.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message_body": message
                            ]
                            var databaseEntryConversations = [[String: Any]]()
                            
                            guard let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
                                return
                            }
                            
                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
                                var targetConversation: [String: Any]?
                                var position = 0
                                
                                for conversationDictionary in otherUserConversations {
                                    if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                        targetConversation = conversationDictionary
                                        break
                                    }
                                    position += 1
                                }
                                
                                if var targetConversation = targetConversation {
                                    targetConversation["latest_message"] = updatedValue
                                    otherUserConversations[position] = targetConversation
                                    databaseEntryConversations = otherUserConversations
                                }
                                else {
                                    // failed to find in current colleciton
                                    let newConversationData: [String: Any] = [
                                        "id": conversation,
                                        "other_user_email": email,
                                        "name": currentName,
                                        "latest_message": updatedValue
                                    ]
                                    otherUserConversations.append(newConversationData)
                                    databaseEntryConversations = otherUserConversations
                                }
                            }
                            else {
                                // current collection does not exist
                                let newConversationData: [String: Any] = [
                                    "id": conversation,
                                    "other_user_email": email,
                                    "name": currentName,
                                    "latest_message": updatedValue
                                ]
                                databaseEntryConversations = [
                                    newConversationData
                                ]
                            }
                            
                            strongSelf.ref.child("\(otherUserEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }
                                
                                completion(true)
                            })
                        })
                    })
                })
            }
        })
        
        
        
        
    }
    
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        print(data)
        print(fileName)
        storageRef.child("message_image/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storageRef.child("message_image/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    
    
    public func uploadAudioMessage(with file: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
           
        storageRef.child("message_audio/\(fileName)").putFile(from: file, metadata: nil, completion: { [weak self] metadata, error in
               guard error == nil else {
                   // failed
                   print("failed to upload data to firebase for picture")
                   completion(.failure(StorageErrors.failedToUpload))
                   return
               }
               
               self?.storageRef.child("message_audio/\(fileName)").downloadURL(completion: { url, error in
                   guard let url = url else {
                       print("Failed to get download url")
                       completion(.failure(StorageErrors.failedToGetDownloadUrl))
                       return
                   }
                   
                   let urlString = url.absoluteString
                   print("download url returned: \(urlString)")
                   completion(.success(urlString))
               })
           })
       }
       
    
    
    public func downloadAudio(with file: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
        
     storageRef.child("message_audio/\(fileName)").putFile(from: file, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storageRef.child("message_audio/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storageRef.child(path)

           reference.downloadURL(completion: { url, error in
               guard let url = url, error == nil else {
                   completion(.failure(StorageErrors.failedToGetDownloadUrl))
                   return
               }

               completion(.success(url))
           })
       }
    
}





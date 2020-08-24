//
//  ChatVC.swift
//  ZomallApp
//
//  Created by Usman on 18/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit
import MessageUI
import MessageKit
import InputBarAccessoryView
import SDWebImage
import AVFoundation

class ChatVC: MessagesViewController,AVAudioRecorderDelegate {
    
    // we will get this through API from HomeScreen Cards
    public var otherUserEmail: String
    open weak var playingCell: AudioMessageCell?
    open var playingMessage: MessageType?
    private var senderPhotoURL: URL?
    private var otherUserPhotoURL: URL?

    public var otherUserName: String
    private  var conversationID: String?
    public var isNewConversation: Bool
    var SoundRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer?
    var fileName: String = ".m4a"
    var audioButton = InputBarButtonItem()
    private var Chats = [chats]()
    var durations: Float?
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
            return nil
        }
        let databaseEmail = FirebaseManager.shared.createEmailString(currentEmail: email)
        return Sender(photoURL: "",
                      senderId: databaseEmail,
                      displayName: "Me")
        
    }
    
    init(with email: String, otherUserName: String,id:String?,isNewConversation:Bool) {
        self.otherUserEmail = email
        self.otherUserName = otherUserName
        self.conversationID = id
        self.isNewConversation = isNewConversation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        messageInputBar.inputTextView.becomeFirstResponder()
        setupInputButton()
        if let conversationID = conversationID{
            print(conversationID)
            listenForChats(id:conversationID,shouldScrollToBottom: true)}
        }
    
    
    @objc func long(gesture:UILongPressGestureRecognizer){
        
        if gesture.state == UIGestureRecognizer.State.began{
            
            recordAudio()
        } else{
            stopRecording()
        }
        
        
    }
    
    private func recordAudio(){
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue
        ]
        
        do {
            let audioFileUrl = getAudiFileURL()
            SoundRecorder = try AVAudioRecorder(url: audioFileUrl, settings: settings)
            SoundRecorder.delegate = self
            SoundRecorder.record()
        } catch {
            print("error")
        }


    }
    
    private func stopRecording(){
        SoundRecorder.stop()
        let audioAsset = AVURLAsset.init(url: SoundRecorder.url, options: nil)
        let duration = audioAsset.duration
        let durationIn = CMTimeGetSeconds(duration)
        print(durationIn)
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        let fileName = createChatID()+".aac"
        
        guard let conversationID = self.conversationID,
            let name = self.title,
            let selfSender = self.selfSender
            else{
                return
        }
        
        
        FirebaseManager.shared.uploadAudioMessage(with: SoundRecorder.url, fileName: fileName,completion: { [] result in
            switch result{
            case .success(let urlString):
                print("uploaded successfully:\(urlString)")
                
                guard let url = URL(string: urlString)
                    
                    else{
                        return
                }
                
                let audio = Audio(url: url, duration: Float(durationIn), size: .zero)
                
                let message = chats(messageId: self.createChatID(),
                                    sender:selfSender,
                                    sentDate: Date(),
                                    kind: .audio(audio))
                
                FirebaseManager.shared.sendMessage(to: conversationID , name: name, otherUserEmail: self.otherUserEmail, newMessage: message, completion: { success in
                                   
                                   
                                   if success {
                                       print("Audio message sent")
                                   }else{
                                       print("failed to send")
                                   }
                               })
                
                
            case .failure(let error):
                print("failed")
                
                
            }
        })
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getAudiFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(".aac")
    }
    private func setupInputButton(){
        let attachButton = InputBarButtonItem()
        
        attachButton.setSize(CGSize(width: 35, height: 35), animated: false)
        attachButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        audioButton.setSize(CGSize(width: 35, height: 35), animated: false)
        audioButton.setImage(UIImage(systemName: "mic.circle"), for: .normal)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        audioButton.addGestureRecognizer(longGesture)
        attachButton.onTouchUpInside { (_) in
            self.presentActionSheet()
        }
        
                
        messageInputBar.setLeftStackViewWidthConstant(to: 35, animated: false)
        
        
        
        
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setStackViewItems([audioButton], forStack: .right, animated: false)
        
        
    }
    
    private func presentActionSheet(){
        let actionSheet = UIAlertController(title: "Choose Media", message: "Select Media Option", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (_) in
            self.selectPhotoAction()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet,animated: true)
    }
    
    private func selectPhotoAction(){
        let actionSheet = UIAlertController(title: "Choose Photo", message: "Select Photos From", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker,animated: true)
            
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker,animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet,animated: true)
        
    }
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in  messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        let borderColor:UIColor = isFromCurrentSender(message: message) ? .clear: .clear
        return .bubbleTailOutline(borderColor, corner, .curved)
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return (isFromCurrentSender(message: message) ? UIColor(named: "ThemeColour") ?? UIColor.blue  : UIColor(named: "reciever") ?? UIColor.gray)
    }
    private func listenForChats(id:String,shouldScrollToBottom: Bool){
        FirebaseManager.shared.loadAllMessages(with: id,completion: { [weak self] result in
            
            switch result{
            case .success(let chat):
                guard !chat.isEmpty else {
                    return
                }
                print(chat)
                self?.Chats = chat
                
                DispatchQueue.main.async {
                    
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScrollToBottom{
                        self?.messagesCollectionView.scrollToLastItem()                    }
                    
                    
                }
                
                
            case .failure(let error):
                print(error)
            }
        })
        
    }
    
    
    
    
}
extension ChatVC: MessagesLayoutDelegate, MessagesDisplayDelegate, MessagesDataSource, AVAudioPlayerDelegate{
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return Chats[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return Chats.count
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {

    let sender = message.sender

    if sender.senderId == selfSender?.senderId {
        // show our image
        if let currentUserImageURL = self.senderPhotoURL {
            avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
        }
        else {
        // images/safeemail_profile_picture.png
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }

            let safeEmail = FirebaseManager.shared.createEmailString(currentEmail: email)
        let path = "Images/\(safeEmail)_profile_pic.png"
        FirebaseManager.shared.downloadURL(for: path, completion: { [weak self] result in
                switch result {
                case .success(let url):
                    self?.senderPhotoURL = url
                    DispatchQueue.main.async {
                        avatarView.sd_setImage(with: url, completed: nil)
                    }
                case .failure(let error):
                    print("\(error)")
                }
            })
        }
    } else{
        if let otherUserUrl = self.otherUserPhotoURL {
                    avatarView.sd_setImage(with: otherUserUrl, completed: nil)
                }
                else {
                    // fetch url
                    let email = self.otherUserEmail

            let safeemail = FirebaseManager.shared.createEmailString(currentEmail: email)
                    let path = "Images/\(safeemail)_profile_pic.png"

                    // fetch url
                    FirebaseManager.shared.downloadURL(for: path, completion: { [weak self] result in
                        switch result {
                        case .success(let url):
                            self?.otherUserPhotoURL = url
                            DispatchQueue.main.async {
                                avatarView.sd_setImage(with: url, completed: nil)
                            }
                        case .failure(let error):
                            print("\(error)")
                        }
                    })
                }
            }
    }
        

    
    func currentSender() -> SenderType {
        if let sender = selfSender{
            return sender
        }
        fatalError("Self Sender is nil")
    }
    
    private func createChatID() -> String{
        let identifier = UUID()
        return (identifier.uuidString + selfSender!.senderId)
    }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        if text == ""{
            messageInputBar.setStackViewItems([audioButton], forStack: .right, animated: false)
        } else{
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
        }
    }
    
    
    
    
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        guard let message = message as? chats else{
            return
            
        }
        switch message.kind{
        case .photo(let media):
            guard let imageURL = media.url else{
                return
            }
            imageView.sd_setImage(with: imageURL, completed: nil)
            
        default:
            break
        }
    }
        func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return self.isFromCurrentSender(message: message) ? .white : .green
        }

        
    
    
    }

    
    

extension ChatVC: MessageCellDelegate{
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    

    
     func didTapPlayButton(in cell: AudioMessageCell) {
        
  if let index = messagesCollectionView.indexPath(for: cell){
        
        if cell.playButton.isSelected == true{

            didPauseAudio(in: cell, indexPath: index)
            
        } else if cell.progressView.progress != 0{
                audioController.resumeSound()

            
        } else {
            
                audioController.playSound(for: messageForItem(at: index, in: messagesCollectionView), in: cell)
            }
        }
    }
    

    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }

    func didPauseAudio(in cell: AudioMessageCell, indexPath: IndexPath) {
            
            
                audioController.pauseSound(for: messageForItem(at: indexPath, in: messagesCollectionView), in: cell)
        
    }

    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }

     open func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        playingCell = cell
     audioController.configureAudioCell(cell, message: message) // this is needed especily when the cell is reconfigure while is playing sound

                    
    }

    
    
    
}

extension ChatVC: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender
            else{
                return
        }
        // Sending Message Now
        let message = chats(messageId: createChatID(),
                            sender:selfSender,
                            sentDate: Date(),
                            kind: .text(text))
        if isNewConversation{
            //create New Conversation
            FirebaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: message, otherUserName: otherUserName,  completion: { success in
                
                if success {
                    print("Message Sent")
                    self.isNewConversation = false
                    let newConversationId = "conversation_\(message.messageId)"
                    self.conversationID = newConversationId
                    self.listenForChats(id: newConversationId, shouldScrollToBottom: true)
                    self.messageInputBar.inputTextView.text = nil
                } else{
                    print("Message Failed")
                }
                
            })
        } else {
            // append to existing
            guard let conversation_ID = conversationID, let name = self.title else{
                return
            }
            FirebaseManager.shared.sendMessage(to: conversation_ID, name: name, otherUserEmail:otherUserEmail, newMessage: message, completion: { success in
                
                
                if success{
                    print("message sent")
                } else{
                    print("not sent")
                }
            })
            
        }
        
    }
}
extension MessageKind {
    var messageType: String {
        switch self{
            
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "custom"
            
        }
    }
}
extension ChatVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage,
            let imageData = image.pngData(),
            let conversationID = conversationID,
            let name = self.title,
            let selfSender = self.selfSender
            else{
                return
        }
        let filename = "photo-message-"+createChatID()+".png"
        print(imageData)
        print(filename)
        FirebaseManager.shared.uploadMessagePhoto(with: imageData, fileName: filename, completion: { [] result in
            switch result{
            case .success(let urlString):
                print("uploaded successfully:\(urlString)")
                
                guard let url = URL(string: urlString),
                    let placeholderImage = UIImage(systemName: "plus") else{
                        return
                }
                print(url)
                let media = Media(url: url, image: nil, placeholderImage: placeholderImage, size: .zero)
                let message = chats(messageId: self.createChatID(),
                                    sender:selfSender,
                                    sentDate: Date(),
                                    kind: .photo(media))
                
                FirebaseManager.shared.sendMessage(to: conversationID , name: name, otherUserEmail: self.otherUserEmail, newMessage: message, completion: { success in
                    
                    
                    if success {
                        print("Photo message sent")
                    }else{
                        print("failed to send")
                    }
                })
            case.failure(let error):
                print("Failed to upload")
            }
            
        })
    }
}


//
//  chatModel.swift
//  ZomallApp
//
//  Created by Usman on 18/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation
import MessageUI
import MessageKit

struct chats: MessageType {
     var messageId: String
     var sender: SenderType
     var sentDate: Date
     var kind: MessageKind
}
struct Sender: SenderType {
     var photoURL: String
     var senderId: String
     var displayName: String
}
struct Media: MediaItem{
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
struct Audio: AudioItem{
    var url: URL
    var duration: Float
    var size: CGSize
    
}

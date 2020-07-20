//
//  chatModel.swift
//  ZomallApp
//
//  Created by Usman on 18/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation
import MessageKit

struct chats: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}
    

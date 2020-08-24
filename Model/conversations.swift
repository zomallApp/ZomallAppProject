//
//  conversations.swift
//  ZomallApp
//
//  Created by Usman on 27/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation

struct Conversations {
    let id: String
    let name: String
    let otherUserEmail: String
    let latest_message: LatestMessage
}
struct LatestMessage {
    let date: String
    let text: String
    let is_read: Bool
}

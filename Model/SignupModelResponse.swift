//
//  SignupModelResponse.swift
//  ZomallApp
//
//  Created by Baskt QA on 16/09/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation
struct SignupResponseModel : Codable {
    let status : String?
    let message : String?
    let userData : UserData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case userData = "peoples"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        userData = try values.decodeIfPresent(UserData.self, forKey: .userData)
    }

}

struct UserData : Codable {
    let user_id : String?
    let user_name : String?
    let send_match : String?
    let gender : String?
    let age : String?
    let bio : String?
    let lat : String?
    let lon : String?
    let token : String?
    let timestamp : String?
    let online : String?
    let location : String?
    let info : String?
    let interest : String?
    let user_image : String?
    let images : String?
    let show_age : String?
    let show_distance : String?
    let invisible : String?
    let report : String?
    let premium_member : String?
    let message_notification : String?
    let like_notification : String?
    let hide_ads : String?
    let admin_enable_ads : String?
    let ad_unit_id : String?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case user_name = "user_name"
        case send_match = "send_match"
        case gender = "gender"
        case age = "age"
        case bio = "bio"
        case lat = "lat"
        case lon = "lon"
        case token = "token"
        case timestamp = "timestamp"
        case online = "online"
        case location = "location"
        case info = "info"
        case interest = "interest"
        case user_image = "user_image"
        case images = "images"
        case show_age = "show_age"
        case show_distance = "show_distance"
        case invisible = "invisible"
        case report = "report"
        case premium_member = "premium_member"
        case message_notification = "message_notification"
        case like_notification = "like_notification"
        case hide_ads = "hide_ads"
        case admin_enable_ads = "admin_enable_ads"
        case ad_unit_id = "ad_unit_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        send_match = try values.decodeIfPresent(String.self, forKey: .send_match)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        age = try values.decodeIfPresent(String.self, forKey: .age)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lon = try values.decodeIfPresent(String.self, forKey: .lon)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        online = try values.decodeIfPresent(String.self, forKey: .online)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        info = try values.decodeIfPresent(String.self, forKey: .info)
        interest = try values.decodeIfPresent(String.self, forKey: .interest)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        images = try values.decodeIfPresent(String.self, forKey: .images)
        show_age = try values.decodeIfPresent(String.self, forKey: .show_age)
        show_distance = try values.decodeIfPresent(String.self, forKey: .show_distance)
        invisible = try values.decodeIfPresent(String.self, forKey: .invisible)
        report = try values.decodeIfPresent(String.self, forKey: .report)
        premium_member = try values.decodeIfPresent(String.self, forKey: .premium_member)
        message_notification = try values.decodeIfPresent(String.self, forKey: .message_notification)
        like_notification = try values.decodeIfPresent(String.self, forKey: .like_notification)
        hide_ads = try values.decodeIfPresent(String.self, forKey: .hide_ads)
        admin_enable_ads = try values.decodeIfPresent(String.self, forKey: .admin_enable_ads)
        ad_unit_id = try values.decodeIfPresent(String.self, forKey: .ad_unit_id)
    }

}


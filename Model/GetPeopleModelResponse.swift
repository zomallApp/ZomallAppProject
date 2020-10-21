//
//  GetPeopleModelResponse.swift
//  ZomallApp
//
//  Created by Baskt QA on 20/10/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import Foundation

struct GetPeopleForSwipes : Codable {
    let status : String?
    let userData : [UserInfo]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case userData = "peoples"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        userData = try values.decodeIfPresent([UserInfo].self, forKey: .userData)
    }

}
struct UserInfo : Codable {
    let user_id : String?
    let index : Int?
    let user_name : String?
    let send_match : String?
    let gender : String?
    let age : String?
    let bio : String?
    let lat : String?
    let lon : String?
    let online : String?
    let location : String?
    let info : String?
    let interest : String?
    let user_image : String?
    let images : String?
    let show_age : String?
    let show_location : String?
    let invisible : String?
    let premium_member : String?
    let report : String?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case index = "index"
        case user_name = "user_name"
        case send_match = "send_match"
        case gender = "gender"
        case age = "age"
        case bio = "bio"
        case lat = "lat"
        case lon = "lon"
        case online = "online"
        case location = "location"
        case info = "info"
        case interest = "interest"
        case user_image = "user_image"
        case images = "images"
        case show_age = "show_age"
        case show_location = "show_location"
        case invisible = "invisible"
        case premium_member = "premium_member"
        case report = "report"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        index = try values.decodeIfPresent(Int.self, forKey: .index)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        send_match = try values.decodeIfPresent(String.self, forKey: .send_match)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        age = try values.decodeIfPresent(String.self, forKey: .age)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lon = try values.decodeIfPresent(String.self, forKey: .lon)
        online = try values.decodeIfPresent(String.self, forKey: .online)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        info = try values.decodeIfPresent(String.self, forKey: .info)
        interest = try values.decodeIfPresent(String.self, forKey: .interest)
        user_image = try values.decodeIfPresent(String.self, forKey: .user_image)
        images = try values.decodeIfPresent(String.self, forKey: .images)
        show_age = try values.decodeIfPresent(String.self, forKey: .show_age)
        show_location = try values.decodeIfPresent(String.self, forKey: .show_location)
        invisible = try values.decodeIfPresent(String.self, forKey: .invisible)
        premium_member = try values.decodeIfPresent(String.self, forKey: .premium_member)
        report = try values.decodeIfPresent(String.self, forKey: .report)
    }

}


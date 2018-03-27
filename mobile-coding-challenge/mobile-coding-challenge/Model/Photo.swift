//
//  Photo.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-26.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation

// not the full json structure, only the useful ones
struct Photo: Decodable {
    let id: String
    let created: Date
    let updated: Date
    let description: String?
    let user: User
    let url: String  // this is a nested value

    enum CodingKeys: String, CodingKey {
        case id
        case created = "created_at"
        case updated = "updated_at"
        case description
        case user
        case urls
    }

    enum UrlsKeys: String, CodingKey {
        case regular // take out regular url from urls, as url property to use
    }
}

extension Photo {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        created = try values.decode(Date.self, forKey: .created)
        updated = try values.decode(Date.self, forKey: .updated)
        description = try values.decodeIfPresent(String.self, forKey: .description)  // optional !!!
        user = try values.decode(User.self, forKey: .user)
//        // to handle the nested value
        let urls = try values.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls)
        url = try urls.decode(String.self, forKey: .regular)
    }
}

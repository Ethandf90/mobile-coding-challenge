//
//  PhotoDetail.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-27.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation

struct PhotoDetail: Decodable {
    let id: String
    let created: Date
    let updated: Date
    let description: String?
    let user: User
    let url: String  // this is a nested value
    
    let likes: Int
    let views: Int
    let downloads: Int

    enum CodingKeys: String, CodingKey {
        case id
        case created = "created_at"
        case updated = "updated_at"
        case description
        case user
        case urls
        case likes
        case views
        case downloads
    }

    enum UrlsKeys: String, CodingKey {
//        case full // take out 'full' url from urls, as url property to use
        case regular
    }
    
}

extension PhotoDetail {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        created = try values.decode(Date.self, forKey: .created)
        updated = try values.decode(Date.self, forKey: .updated)
        description = try values.decodeIfPresent(String.self, forKey: .description) // optional !!!
        user = try values.decode(User.self, forKey: .user)
        likes = try values.decode(Int.self, forKey: .likes)
        views = try values.decode(Int.self, forKey: .views)
        downloads = try values.decode(Int.self, forKey: .downloads)

        // to handle the nested value
        let urls = try values.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls)
        url = try urls.decode(String.self, forKey: .regular)
    }
}

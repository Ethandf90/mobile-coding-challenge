//
//  User.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-27.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let username: String
    let name: String
    let location: String?
}

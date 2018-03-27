//
//  Constants.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-26.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation

struct Constants {
    #if DEBUG
    static let baseURL = "https://api.unsplash.com"
    static let auth = "Client-ID 4d9b5542d9cc59b62751cd284d4cfb486707cf997526e62c3b5fead1128fc8d2"
    #else
    #endif
    
}

enum Errors: Error {
    case invalidURL
}

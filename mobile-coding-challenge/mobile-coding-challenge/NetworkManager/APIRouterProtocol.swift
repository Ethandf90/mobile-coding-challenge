//
//  APIRouterProtocol.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-26.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Alamofire

// have procotol if several routers
protocol APIRouterProtocol: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var queryItems: [URLQueryItem]? { get }
}


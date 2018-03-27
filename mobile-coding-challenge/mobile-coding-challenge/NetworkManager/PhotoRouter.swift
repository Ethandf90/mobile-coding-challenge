//
//  PhotoRouter.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-26.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Alamofire

enum PhotoRouter: APIRouterProtocol {
    
    case photos(page: Int)
    case photo(id: String)
    
    // MARK: - HTTPMethod
    internal var method: HTTPMethod {
        switch self {
//        case .login:
//            return .post
        case .photos, .photo:
            return .get
        }
    }
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .photo(let id):
            return "/photos/\(id)"
        case .photos(let page):
            return "/photos"
        }
    }
    
    // for GET like ...?key=value
    internal var queryItems: [URLQueryItem]? {
        switch self {
        case .photo:
            return nil
        case .photos(let page):
            return [URLQueryItem(name: "page", value: String(page))]
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        switch self {
//        case .login(let email, let password):
//            return ["email": email, "password": password]
        case .photo, .photos:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var urlComponent = URLComponents(string: Constants.baseURL + path)
        
        if let query = queryItems {
            urlComponent?.queryItems = query
        }
        
        guard let url = urlComponent?.url else { throw Errors.invalidURL }
        var urlRequest = URLRequest(url: url)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("v1", forHTTPHeaderField: "Accept-Version")
        urlRequest.setValue(Constants.auth, forHTTPHeaderField: "Authorization")  // todo: hardcode for now
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}

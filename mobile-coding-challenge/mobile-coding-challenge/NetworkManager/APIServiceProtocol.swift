//
//  APIClientProtocol.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-26.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Alamofire

protocol APIServiceProtocol {
    static func performRequest<T:Decodable>(route:APIRouterProtocol, decoder: JSONDecoder , completion:@escaping (Result<T>)->Void) -> DataRequest
}

extension APIServiceProtocol {
    @discardableResult
    internal static func performRequest<T:Decodable>(route:APIRouterProtocol, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        
        // option 1: use responseJSON with SwiftyJSON to generate model
        // ...
        

        
        // option 2: swift 4 codable
        return Alamofire.request(route).responseData(completionHandler: { (response: DataResponse<Data>) in
            switch response.result {
            case .success(let data):
                do {
                    let object = try decoder.decode(T.self, from: data)
                     completion(Result.success(object))
                }
                catch {
                     completion(Result.failure(error))
                }
            case .failure(let error): return completion(Result.failure(error))
            }
        })
    }
}

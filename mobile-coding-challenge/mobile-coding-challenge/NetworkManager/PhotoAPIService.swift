//
//  PhotoAPIService.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-26.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Alamofire

class PhotoAPIService: APIServiceProtocol {
    
    static func getPhotos(from page: Int = 1, completion:@escaping (Result<[Photo]>) -> Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.photoDateFormatter)
        performRequest(route: PhotoRouter.photos(page: page), decoder: jsonDecoder, completion: completion)
    }
    
    static func getPhoto(by id: String, completion: @escaping (Result<PhotoDetail>) -> Void ) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.photoDateFormatter)
        performRequest(route: PhotoRouter.photo(id: id), decoder: jsonDecoder, completion: completion)
    }
}

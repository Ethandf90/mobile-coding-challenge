//
//  ViewController.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-26.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhotoAPIService.getPhotos(from: 1){ result in
            switch result {
            case .success(let photos):
                print("_____________________________")
                print(photos)
            case .failure(let error):
                print(error)
            }
        }
        
        PhotoAPIService.getPhoto(by: "8qrnOP1s6H4") { (result) in
            switch result {
            case .success(let photo):
                print("_____________________________")
                print(photo)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }



}


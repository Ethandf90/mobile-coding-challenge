//
//  UIImage+Extension.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-27.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation
import UIKit

typealias DemoAsset = UIImage.Asset

//usage: DemoAsset.placehoder.image  -> UIImage

extension UIImage {
    enum Asset : String {
        case placeholder = "placeholder"

        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

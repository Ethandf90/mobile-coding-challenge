//
//  UIImageView+Extension.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-27.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation
import Kingfisher


extension UIImageView {
    
    func setImageWith(urlStr: String?, placeholder: UIImage = DemoAsset.placeholder.image)
    {
        
        if let str = urlStr {
            let url = URL(string: str)
            self.kf.setImage(with: url, placeholder: placeholder)
        } else {
            //todo
            self.kf.setImage(with: nil, placeholder: placeholder)
        }
        
    }
    
    func setImageWith(localFile: String?)
    {
        if let localFileStr = localFile {
            let aURL = URL(fileURLWithPath: localFileStr)
            self.kf.setImage(with: aURL)
        }
    }
    
    func setImageWith(urlStr: String?, completionHandler: ((NSError?) -> ())?)
    {
        if let str = urlStr {
            let url = URL(string: str)
            self.kf.setImage(with: url, completionHandler: {
                (image, error, cacheType, imageUrl) in
                if error != nil {
                    completionHandler!(error!)
                } else {
                    completionHandler!(nil)
                }
            })
        } else {
            let anError = NSError(domain: "UIImageView setImageWith had an error", code: -1, userInfo: nil)
            completionHandler!(anError)
        }
    }
}



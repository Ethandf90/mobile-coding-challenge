//
//  UIView+Extension.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-27.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
//    func addBlurEffect()
//    {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
//        self.addSubview(blurEffectView)
//    }
    
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}

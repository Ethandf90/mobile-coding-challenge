//
//  ViewControllerProtocol.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-28.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation
import UIKit

// the shared functions for viewcontrollers
// instead of subclassing viewcontroller, use protocol
protocol ViewControllerProtocol {
    func addSubviews()
    func addConstraints()
    func loadData()  // might be optional, so provide default implementation, which does nothing
}

extension ViewControllerProtocol where Self: UIViewController {
    func loadData() {
    }
}

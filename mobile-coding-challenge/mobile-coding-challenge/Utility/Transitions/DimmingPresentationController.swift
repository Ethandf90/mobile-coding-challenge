//
//  DimmingPresentationController.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-28.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {

    lazy var background = UIView(frame: .zero)
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        setupBackground()
        // Grabing the coordinator responsible for the presentation so that the background can be animated at the same rate
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (_) in
                self.background.alpha = 1
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (_) in
                self.background.alpha = 0
            }, completion: nil)
        }
    }
    
    private func setupBackground() {
        background.backgroundColor = UIColor.black
        background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        background.frame = containerView!.bounds
        containerView!.insertSubview(background, at: 0)
        background.alpha = 0
    }
}

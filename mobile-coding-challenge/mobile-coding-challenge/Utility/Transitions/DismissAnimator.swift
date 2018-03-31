//
//  DismissAnimator.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-28.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation
import UIKit

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let indexPath: IndexPath
    private let finalFrame: CGRect
    private let duration: TimeInterval = 0.5
    
    init(pageIndex: Int, finalFrame: CGRect) {
        self.indexPath = IndexPath(item: pageIndex, section: 0)
        self.finalFrame = finalFrame
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: .to) as? CollectionViewController,
            let fromVC = transitionContext.viewController(forKey: .from) as? DetailCollectionViewController,
            let detailCollectionViewCell = fromVC.imageCollectionView.cellForItem(at: indexPath) as? DetailCollectionViewCell
            else {
                transitionContext.completeTransition(true)
                return
        }
        
        let containerView = transitionContext.containerView
        
        // Determine our original and final frames
        let size = detailCollectionViewCell.imageView.frame.size
        let convertedRect = detailCollectionViewCell.imageView.convert(detailCollectionViewCell.imageView.bounds, to: containerView)
        let originFrame = CGRect(origin: convertedRect.origin, size: size)

        let viewToAnimate = UIImageView(frame: originFrame)
        viewToAnimate.center = CGPoint(x: convertedRect.midX, y: convertedRect.midY)
        viewToAnimate.image = detailCollectionViewCell.imageView.image
        viewToAnimate.contentMode = .scaleAspectFill
        viewToAnimate.clipsToBounds = true
        
        containerView.addSubview(viewToAnimate)
        
        toVC.collectionView.cellForItem(at: self.indexPath)?.isHidden = true
        fromVC.view.isHidden = true
        
        // Animate size and position
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.frame.size.width = self.finalFrame.width
            viewToAnimate.frame.size.height = self.finalFrame.height
            viewToAnimate.center = CGPoint(x: self.finalFrame.midX, y: self.finalFrame.midY)
        }, completion: { _ in
            toVC.collectionView.cellForItem(at: self.indexPath)?.isHidden = false
            viewToAnimate.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

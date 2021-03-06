//
//  PresentAnimator.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-28.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import Foundation
import UIKit

class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let indexPath: IndexPath
    private let originFrame: CGRect
    private let duration: TimeInterval = 1

    init(pageIndex: Int, originFrame: CGRect) {
        self.indexPath = IndexPath(item: pageIndex, section: 0)
        self.originFrame = originFrame
        super.init()
    }

    // protocol func
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from) as? CollectionViewController,
            let fromView = fromVC.collectionView.cellForItem(at: indexPath) as? CollectionViewCell
            else {
                transitionContext.completeTransition(true)
                return
        }
        var finalFrame = toView.frame // assign whole screen frame
        if UIDevice.current.orientation == .portrait {
            finalFrame.size.height = finalFrame.height - 100 // 100 is constraint constant
        } else {
            finalFrame.size.width = finalFrame.width - 200 // 200 is constraint constant
        }
        
        let viewToAnimate = UIImageView(frame: originFrame)
        viewToAnimate.image = fromView.imageView.image
        viewToAnimate.contentMode = .scaleAspectFill
        viewToAnimate.clipsToBounds = true
        fromView.imageView.isHidden = true

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.addSubview(viewToAnimate)

        toView.isHidden = true

        // Determine the final image height based on final frame width and image aspect ratio
        let imageAspectRatio = viewToAnimate.image!.size.width / viewToAnimate.image!.size.height
        let finalImageheight = finalFrame.width / imageAspectRatio

        // Animate size and position
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.frame.size.width = finalFrame.width
            viewToAnimate.frame.size.height = finalImageheight
            viewToAnimate.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion:{ _ in
            toView.isHidden = false
            fromView.imageView.isHidden = false
            viewToAnimate.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

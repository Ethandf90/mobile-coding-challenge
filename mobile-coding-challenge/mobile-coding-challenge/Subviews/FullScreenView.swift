//
//  FullScreenView.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-27.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import UIKit
import SnapKit

protocol FullScreenViewProtocol: NSObjectProtocol {
    func dismiss()
}

class FullScreenView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var blurBackgroundView: UIView! {
        didSet {
            blurBackgroundView.addBlurEffect()
        }
    }
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    
    weak var delegate: FullScreenViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FullScreenView", owner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
//        tap.numberOfTapsRequired = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    // MARK: public func
    
    func updateContent(with model: PhotoDetail) {
        
        
        self.imageView.setImageWith(urlStr: model.url, placeholder: DemoAsset.placeholder.image)
        self.viewsLabel.text = String(model.views)
        self.downloadsLabel.text = String(model.downloads)
    }
    
    // MARK: gesture handler
    
    @objc func tapToDismiss() {
        self.delegate?.dismiss()
    }
}

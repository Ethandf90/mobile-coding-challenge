//
//  CollectionViewCell.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-27.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView(frame: self.contentView.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var label: UILabel = { [unowned self] in
        let frame = CGRect(x: self.contentView.frame.size.width * 0.03, y: self.contentView.center.y - self.contentView.frame.size.height * 0.25,
                           width: self.contentView.frame.size.width * 0.94, height: self.contentView.frame.size.height * 0.5)
        let label = UILabel(frame: frame)
        label.font = UIFont.ProximaNovaSemibold(ofSize: 15)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.text = ""
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellWith(model: Photo) {
        // to address resue issue
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        contentView.addSubview(imageView)
//        contentView.bringSubview(toFront: label)
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        imageView.setImageWith(urlStr: model.url)
    }
}

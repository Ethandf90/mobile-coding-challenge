//
//  DetailCollectionViewCell.swift
//  mobile-coding-challenge
//
//  Created by FEI DONG on 2018-03-31.
//  Copyright © 2018 FEI DONG. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFit
//            imageView.setImageWith(urlStr: nil, placeholder: DemoAsset.placeholder.image)
        }
    }
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    
    var model: Photo? = nil {
        didSet {
            if let model = model {
                imageView.setImageWith(urlStr: model.url, placeholder: DemoAsset.placeholder.image)
            } else {
                imageView.image = nil
            }
        }
    }
    var detailModel: PhotoDetail? = nil {
        didSet {
            if let model = detailModel {
                imageView.setImageWith(urlStr: model.url, placeholder: DemoAsset.placeholder.image)
                downloadsLabel.text = String(model.downloads)
                viewsLabel.text = String(model.views)
            } else {
                imageView.image = nil
                downloadsLabel.text = "-"
                viewsLabel.text = "-"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        detailModel = nil
    }
    
    func configureForNewImage(animated: Bool = true) {
        if let model = model {
            imageView.setImageWith(urlStr: model.url, placeholder: DemoAsset.placeholder.image)
//            imageView.sizeToFit()
            
            if animated {
                imageView.alpha = 0.0
                UIView.animate(withDuration: 0.5) {
                    self.imageView.alpha = 1.0
                }
            }
        }
    }
}

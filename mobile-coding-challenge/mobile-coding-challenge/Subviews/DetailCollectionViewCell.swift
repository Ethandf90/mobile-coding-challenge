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
            imageView.image = DemoAsset.placeholder.image
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

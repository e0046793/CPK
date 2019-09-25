//
//  FlickrCollectionViewCell.swift
//  Fetch
//
//  Created by Nhan Truong on 24/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import UIKit

class FlickrCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "FlickrCell"
 
    @IBOutlet weak var imgViewThumbnail: UIImageView!
    
    override func awakeFromNib() {
        // Use a random background color.
        let redColor = CGFloat(arc4random_uniform(255)) / 255.0
        let greenColor = CGFloat(arc4random_uniform(255)) / 255.0
        let blueColor = CGFloat(arc4random_uniform(255)) / 255.0
        self.backgroundColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgViewThumbnail.image = nil
    }
    
    func configure(with model: PhotoViewModel!) {
        guard let model = model else { return }
        self.imgViewThumbnail.image = model.image
    }
}

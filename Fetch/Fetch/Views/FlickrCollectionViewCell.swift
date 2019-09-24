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
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    func configure(with model: FlickrPhoto?) {
        guard let model = model else {
            self.imgViewThumbnail.backgroundColor = .white
            return
        }
        let queue = DispatchQueue.init(label: "com.bearlon.fetchImage")
        queue.async
        {
            if let imageFromCache = self.imageCache.object(forKey: model.id as NSString) {
                DispatchQueue.main.sync { [unowned self] in
                    self.imgViewThumbnail.image = imageFromCache
                }
            }
            
            else if let url =  URL(string: "https://farm\(model.farm).staticflickr.com/\(model.server)/\(model.id)_\(model.secret)_t.jpg"),
                let imageData = try? Data(contentsOf: url) {
                self.imageCache.setObject(UIImage(data: imageData)!, forKey: model.id as NSString)
                
                DispatchQueue.main.sync { [unowned self] in
                    self.imgViewThumbnail.image = UIImage(data: imageData)
                }
            }
        }
    }
}

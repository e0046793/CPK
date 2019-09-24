//
//  ViewController.swift
//  Fetch
//
//  Created by Nhan Truong on 23/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private enum Constant {
        static let ViewName = NSLocalizedString("Flickr", comment: "")
        static let CellID = "cellIdentifier"
    }
    
    private var noOfPhoto: Int = 0
    
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.ViewName
        load(resource: FlickrPhotoPage.firstPage)
    }


}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noOfPhoto
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID, for: indexPath)
        cell.backgroundColor = .white
        return cell
    }

}

extension ViewController: Loading {
    
    func configure(_ value: FlickrPhotoPage) {
        self.noOfPhoto = value.photos.count
        collectionView.reloadData()
    }
}


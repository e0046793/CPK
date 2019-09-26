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
    private enum TEXT {
        static let Title      = "Flickr".localizedString
        static let AlertTitle = "Warning".localizedString
        static let OK         = "OK".localizedString
    }
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    private var viewModel: PageViewModel! {
        didSet {
            guard nil != viewModel else { return }
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TEXT.Title
        
        setupView()
        
        viewModel = PageViewModel(
            request: FlickrPhotoPage.firstPage,
            delegate: self,
            loadingDelegate: self
        )
        viewModel.fetchPhotos()
    }


}

extension ViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FlickrCollectionViewCell.cellIdentifier,
            for: indexPath) as! FlickrCollectionViewCell
       
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            viewModel.loadPhoto(at: indexPath.row) {
                cell.configure(with: $0)
            }
        }
        return cell
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    // MARK: - UICollectionViewDataSourcePrefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPhotos()
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Dimiss the highlight
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension ViewController: PageViewModelDelegate {
    // MARK: - PageViewModelDelegate
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }
    
    func onFetchFailed(with reason: String) {
        let action = UIAlertAction(title: TEXT.OK, style: .default)
        displayAlert(with: TEXT.AlertTitle , message: reason, actions: [action])
    }
}

fileprivate extension ViewController {
    // MARK: - Private methods 
    func setupView() {
        collectionView.refreshControl = self.refreshControl
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.refresh()
        refreshControl.endRefreshing()
    }
}

extension ViewController: Loading, AlertDisplayer {}


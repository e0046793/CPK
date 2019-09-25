//
//  PageViewModel.swift
//  Fetch
//
//  Created by kyle on 24/09/2019.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import UIKit

protocol PageViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class PageViewModel {
    private weak var delegate: PageViewModelDelegate?
    
    private var photos: [FlickrPhoto] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    private let cache = NSCache<NSString, UIImage>()
    
    let client = APIManager()
    let request: Resource<FlickrPhotoPage>
    
    init(request: Resource<FlickrPhotoPage>, delegate: PageViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return photos.count
    }
    
    func photo(at index: Int) -> FlickrPhoto {
        return photos[index]
    }
    
    func fetchPhotos() {
        // 1
        guard !isFetchInProgress else { return }
        
        // 2
        isFetchInProgress = true
        
        client.getRequest(FlickrPhotoPage.loadPage(currentPage)) { (result) in
            switch result {
            case .error(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let flickrPhotoPage):
                DispatchQueue.main.async {
                    // 1
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    // 2
                    self.total = flickrPhotoPage.total
                    self.photos.append(contentsOf: flickrPhotoPage.photos)
                    
                    // 3
                    if 1 < flickrPhotoPage.page {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: flickrPhotoPage.photos)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    func loadPhoto(at index: Int, completion: @escaping (PhotoViewModel) -> ()) {
        let model = photo(at: index)
        
        if let cachedImage = self.cache.object(forKey: model.id as NSString) {
            let photoVM = PhotoViewModel(image: cachedImage)
            completion(photoVM)
        
        } else {
            let request = Resource<PhotoViewModel>(url: model.imageURL) { (data) -> PhotoViewModel? in
                guard let image = UIImage(data: data) else { return nil }
                self.cache.setObject(image, forKey: model.id as NSString)
                return PhotoViewModel(image: image)
            }
            client.getRequest(request) { result in
                switch result {
                case .error(let error):
                    print(error.localizedDescription)
                case .success(let photoViewModel):
                    DispatchQueue.main.async {
                        completion(photoViewModel)
                    }
                }
            }
        }
    }
    
}

private extension PageViewModel {
    
    func calculateIndexPathsToReload(from newModerators: [FlickrPhoto]) -> [IndexPath] {
        let startIndex = photos.count - newModerators.count
        let endIndex = startIndex + newModerators.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

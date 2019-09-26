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
    private weak var loadingDelegate: LoadingWebservice?
    
    private var photos: [FlickrPhoto] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false {
        didSet {
            if true == isFetchInProgress { loadingDelegate?.willInvokeService() }
            else { loadingDelegate?.didServiceResponse() }
        }
    }
    private let cache = NSCache<NSString, UIImage>()
    
    private let client = APIManager()
    private let request: Resource<FlickrPhotoPage>
    
    init(request: Resource<FlickrPhotoPage>, delegate: PageViewModelDelegate, loadingDelegate: LoadingWebservice? = nil) {
        self.request = request
        self.delegate = delegate
        self.loadingDelegate = loadingDelegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return photos.count
    }
    
    func refresh() {
        self.invokeWebservice(request: FlickrPhotoPage.firstPage) { flickrPhotoPage in
            self.currentPage = flickrPhotoPage.page + 1
            
            if false == self.photos.isEmpty { self.photos.removeAll() }
            self.photos.append(contentsOf: flickrPhotoPage.photos)
        }
    }
    
    func fetchPhotos() {
        self.invokeWebservice(request: FlickrPhotoPage.loadPage(currentPage)) { flickrPhotoPage in
            self.currentPage += 1
            self.photos.append(contentsOf: flickrPhotoPage.photos)
        }
    }
    
    func loadPhoto(at index: Int, completion: @escaping (PhotoViewModel) -> ()) {
        let model = photo(at: index)
        
        if let cachedImage = self.cache.object(forKey: model.id as NSString) {
            let photoVM = PhotoViewModel(
                thumbnailImage: cachedImage,
                title: model.title,
                url: model.originURL
            )
            completion(photoVM)
        
        } else {
            let request = Resource<PhotoViewModel>(url: model.thumbnailURL) { (data) -> PhotoViewModel? in
                guard let image = UIImage(data: data) else { return nil }
                self.cache.setObject(image, forKey: model.id as NSString)
                return PhotoViewModel(
                    thumbnailImage: image,
                    title: model.title, url:
                    model.originURL
                )
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
    
    func photo(at index: Int) -> FlickrPhoto {
        return photos[index]
    }
    
    func calculateIndexPathsToReload(from newModerators: [FlickrPhoto]) -> [IndexPath] {
        let startIndex = photos.count - newModerators.count
        let endIndex = startIndex + newModerators.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func invokeWebservice(request: Resource<FlickrPhotoPage>, completion: @escaping (FlickrPhotoPage) -> Void) -> Void {
        
        guard !isFetchInProgress else { return }
        
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
                    self.isFetchInProgress = false
                    self.total = flickrPhotoPage.total
                   
                    completion(flickrPhotoPage)

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
}

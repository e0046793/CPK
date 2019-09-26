//
//  PhotoViewModel.swift
//  Fetch
//
//  Created by kyle on 25/09/2019.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import UIKit

protocol PhotoViewModelDelegate: class {
    func onFetchCompleted(image: UIImage)
    func onFetchFailed(with reason: String)
}

final class PhotoViewModel {
    let thumbnailImage: UIImage
    let title: String
    let url: URL
    weak var delegate: PhotoViewModelDelegate?
    weak var loadingDelegate: LoadingWebservice?
    
    init(thumbnailImage: UIImage, title: String, url: URL, delegate: PhotoViewModelDelegate? = nil) {
        self.thumbnailImage = thumbnailImage
        self.title = title
        self.url = url
        self.delegate = delegate
    }
}

extension PhotoViewModel {
    
    func loadPhoto() {
        let request = Resource<UIImage>(url: self.url) {
            return UIImage(data: $0)
        }
        loadingDelegate?.willInvokeService()
        APIManager().getRequest(request) { result in
            self.loadingDelegate?.didServiceResponse()
            switch result {
            case .error(let error):
                DispatchQueue.main.async {
                    self.delegate?.onFetchFailed(with: error.localizedDescription)
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self.delegate?.onFetchCompleted(image: image)
                }
            }
        }
    }
}

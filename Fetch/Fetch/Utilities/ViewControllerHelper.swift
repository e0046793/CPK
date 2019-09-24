//
//  ViewControllerHelper.swift
//  Fetch
//
//  Created by kyle on 24/09/2019.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import UIKit

protocol Loading {
    associatedtype ResourceType
    var spinner: UIActivityIndicatorView! { get set }
    func configure(_ value: ResourceType)
}

extension Loading where Self: UIViewController {
    
    func load(resource: Resource<ResourceType>) {
        spinner.startAnimating()
        flickr.getRecentPhotos(resource) { [weak self] result in
            self?.spinner.stopAnimating()
            guard let value = result.value else { return } // TODO loading error
            self?.configure(value)
        }
    }
}

//
//  FlickPhoto.swift
//  Fetch
//
//  Created by Nhan Truong on 24/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import Foundation

struct FlickrPhoto {
    let id: String
    let farm: Int
    let server: String
    let secret: String
    let title: String
    
    var thumbnailURL: URL {
        var urlComponents = baseURL
        urlComponents.path.append("_m.jpg")
        return urlComponents.url!
    }
    
    var originURL: URL {
        var urlComponents = baseURL
        urlComponents.path.append(".jpg")
        return urlComponents.url!
    }
    
    private var baseURL: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "farm\(self.farm).staticflickr.com"
        urlComponents.path = "/\(self.server)/\(self.id)_\(self.secret)"
        return urlComponents
    }
}

extension FlickrPhoto {
    
    init?(_ dictionary: JSONDictionary) {
        guard let id = dictionary["id"] as? String,
            let farm = dictionary["farm"] as? Int,
            let server = dictionary["server"] as? String,
            let secret = dictionary["secret"] as? String,
            let title = dictionary["title"] as? String else { return nil }
        
        self.id = id
        self.farm = farm
        self.server = server
        self.secret = secret
        self.title = title
    }
}

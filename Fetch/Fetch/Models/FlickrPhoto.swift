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
    
    var imageURL: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "farm\(self.farm).staticflickr.com"
        urlComponents.path = "/\(self.server)/\(self.id)_\(self.secret)_m.jpg"
        return urlComponents.url!
    }
}

extension FlickrPhoto {
    
    init?(_ dictionary: JSONDictionary) {
        guard let id = dictionary["id"] as? String,
            let farm = dictionary["farm"] as? Int,
            let server = dictionary["server"] as? String,
            let secret = dictionary["secret"] as? String else { return nil }
        
        self.id = id
        self.farm = farm
        self.server = server
        self.secret = secret
    }
}

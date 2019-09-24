//
//  FlickrPhotoPage.swift
//  Fetch
//
//  Created by Nhan Truong on 24/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import Foundation

struct FlickrPhotoPage {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photos: [FlickrPhoto]
}

extension FlickrPhotoPage {
    
    init?(_ dictionary: JSONDictionary) {
        guard let page = dictionary["page"] as? Int,
            let pages = dictionary["pages"] as? Int,
            let perpage = dictionary["perpage"] as? Int,
            let total = dictionary["total"] as? Int,
            let photos = dictionary["photo"] as? [JSONDictionary] else { return nil }
        
        self.page = page
        self.pages = pages
        self.perpage = perpage
        self.total = total
        self.photos = photos.compactMap { json in
            FlickrPhoto.init(json)
        }
    }
}

extension FlickrPhotoPage {
    
    static let firstPage = FlickrPhotoPage.loadPage(1)
    
    static func loadPage(_ page: Int) -> Resource<FlickrPhotoPage> {
        var param: DictionaryParam? = [APIHelper.Param.page : String(page)]
        if 1 > page { param = nil }
        
        return Resource<FlickrPhotoPage>(
            apiName: FlickrAPI.RecentPhoto,
            params: param,
            parseJSON: { json in
                guard let response = json as? JSONDictionary,
                    let photos = response["photos"] as? JSONDictionary else { return nil }
                return FlickrPhotoPage.init(photos)
        })
    }
}

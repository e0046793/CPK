//
//  ApiKeys.swift
//  Fetch
//
//  Created by Nhan Truong on 23/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import Foundation



final class APIHelper {
    
    // MARK: - Properties

    private enum Constant {
        
        enum File {
            static let fileName = "ApiKeys"
            static let fileType = "plist"
        }
       
        enum Key {
            static let APIKey    = "key"
            static let APISecret = "secret"
        }
        
        enum URL {
            static let base = " https://www.flickr.com/services/rest/"
        }
        
        enum API {
            static let recentPhoto = "flickr.photos.getRecent"
        }
        
        enum Param {
            static let method         = "method"
            static let apiKey         = "api_key"
            static let format         = "format"
            static let nojsoncallback = "nojsoncallback"
        }
        
        enum DefaultValue {
            static let jsonFormat = "json"
        }
    }
    
    static var APIKey: String {
        let filePath = Bundle.main.path(forResource: Constant.File.fileName, ofType: Constant.File.fileType)
        guard let plist = NSDictionary(contentsOfFile:filePath!) else { return "" }
        guard let value = plist.object(forKey: Constant.Key.APIKey) as? String else { return "" }
        return value
    }
}

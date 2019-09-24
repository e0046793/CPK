//
//  ApiKeys.swift
//  Fetch
//
//  Created by Nhan Truong on 23/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import Foundation

let flickr = APIManager()

enum FlickrAPI {
    case RecentPhoto
}

final class APIHelper {
    
    // MARK: - Private Properties

    private enum Constant {
        
        enum File {
            static let fileName = "ApiKeys"
            static let fileType = "plist"
        }
       
        enum Key {
            static let APIKey    = "key"
            static let APISecret = "secret"
        }
        
        enum Method {
            static let GetRecend = "flickr.photos.getRecent"
        }
    }
    
    enum Param {
        static let method         = "method"
        static let apiKey         = "api_key"
        static let format         = "format"
        static let nojsoncallback = "nojsoncallback"
    }
    
    static var APIKey: String {
        let filePath = Bundle.main.path(forResource: Constant.File.fileName, ofType: Constant.File.fileType)
        guard let plist = NSDictionary(contentsOfFile:filePath!) else { return "" }
        guard let value = plist.object(forKey: Constant.Key.APIKey) as? String else { return "" }
        return value
    }
    
    static var baseURL: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.flickr.com"
        urlComponents.path = "/services/rest/"
        return urlComponents
    }
}

extension APIHelper {
    
    static func composeURL(by name: FlickrAPI) -> URL {
        var urlComponents = APIHelper.baseURL
        let appendMethod: (String) -> URLQueryItem = {
            return URLQueryItem(name: APIHelper.Param.method, value: $0)
        }
        
        if nil == urlComponents.queryItems {
            urlComponents.queryItems = Array<URLQueryItem>()
        }
        
        switch name {
        case .RecentPhoto:
            urlComponents.queryItems?.append(appendMethod(APIHelper.Constant.Method.GetRecend))
        }
        
        let defaultParams: [URLQueryItem] = [
            URLQueryItem(name: APIHelper.Param.apiKey, value: APIHelper.APIKey),
            URLQueryItem(name: APIHelper.Param.format, value: "json"),
            URLQueryItem(name: APIHelper.Param.nojsoncallback, value: "1"),
        ]
        
        urlComponents.queryItems?.append(contentsOf: defaultParams)
        return urlComponents.url!
    }
}

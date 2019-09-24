//
//  APIManager.swift
//  Fetch
//
//  Created by Nhan Truong on 23/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import Foundation

//let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=075b9698c067e2d7451387ff6e8159c4&format=json&nojsoncallback=1")

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource {
   
    init(apiName: FlickrAPI, parseJSON: @escaping (Any) -> A?) {
        self.url = APIHelper.composeURL(by: apiName)
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

typealias JSONDictionary = [String : AnyObject]

public enum Result<A> {
    case success(A)
    case error(Error)
}

extension Result {
    public init(_ value: A?, or error: Error) {
        if let value = value {
            self = .success(value)
        } else {
            self = .error(error)
        }
    }
    
    public var value: A? {
        guard case .success(let v) = self else { return nil }
        return v
    }
}


public enum WebserviceError: Error {
    case other
}

final class APIManager {
    
    /// Return recent photos
    /// - Parameter resource: FlickPhotoPage object
    /// - Parameter completion: completion handler
    func getRecentPhotos<A>(_ resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, _, _) in
            let parsed = data.flatMap(resource.parse)
            let result = Result(parsed, or: WebserviceError.other)
            DispatchQueue.main.async { completion(result) }
        }.resume()
    }
}

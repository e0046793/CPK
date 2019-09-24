//
//  APIManager.swift
//  Fetch
//
//  Created by Nhan Truong on 23/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import Foundation

// MARK: - Alias

typealias JSONDictionary = [String : AnyObject]
typealias DictionaryParam = [String : String]


// MARK: - HTTPURLResponse extension

extension HTTPURLResponse {
  var hasSuccessStatusCode: Bool {
    return 200...299 ~= statusCode
  }
}


// MARK: - Resorce

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource {
   
    init(apiName: FlickrAPI, params: DictionaryParam! = nil, parseJSON: @escaping (Any) -> A?) {
        self.url = APIHelper.composeURL(by: apiName, params: params)
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

public enum Result<A> {
    case success(A)
    case error(WebserviceError)
}

extension Result {
    public init(_ value: A?, or error: WebserviceError) {
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
    case network
    case decoding
    
    var reason: String {
      switch self {
      case .network:
        return NSLocalizedString("An error occurred while fetching data", comment: "")
      case .decoding:
        return NSLocalizedString("An error occurred while decoding data", comment: "")
      }
    }
}


// MARK: - APIManager

final class APIManager {
    
    /// Return recent photos
    /// - Parameter resource: FlickPhotoPage object
    /// - Parameter completion: completion handler
    func getRecentPhotos<A>(_ resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode else {
                    completion(Result.error(WebserviceError.network))
                    return
            }
            
            let parsed = data.flatMap(resource.parse)
            let result = Result(parsed, or: WebserviceError.decoding)
            DispatchQueue.main.async { completion(result) }
        }.resume()
    }
}

//
//  APIManager.swift
//  Fetch
//
//  Created by Nhan Truong on 23/9/19.
//  Copyright © 2019 Nhan Truong. All rights reserved.
//

import Foundation

let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=075b9698c067e2d7451387ff6e8159c4&format=json&nojsoncallback=1")

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource {
    init(url: URL, parseJSON: @escaping (Any) -> A?) {
        self.url = url
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

typealias JSONDictionary = [String : AnyObject]

final class APIManager {
    
    func fetch<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, _, _) in
            let result = data.flatMap(resource.parse)
            completion(result)
        }.resume()
    }
}

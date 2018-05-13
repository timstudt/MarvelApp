//
//  API.swift
//  Marvelicious
//
//  Created by Tim Studt on 11/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

public typealias Parameters = [String: String]

/**
 Base API protocol
 */
public protocol API {
    var baseURL: URL { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var timeoutInterval: TimeInterval { get }
    var allHTTPHeaderFields: Parameters { get }
}

/**
 Base API default values
 */
public extension API {
    var cachePolicy: URLRequest.CachePolicy { return .useProtocolCachePolicy }
    var timeoutInterval: TimeInterval { return 20.0 }
    var allHTTPHeaderFields: Parameters { return Parameters() }

    func urlRequestBuilder(url: URL) -> URLRequestBuilder {
        return URLRequestBuilder(url: url)
            .add(cachePolicy: cachePolicy)
            .add(timeoutInterval: timeoutInterval)
            .add(allHeaderFields: allHTTPHeaderFields)
    }
}

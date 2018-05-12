//
//  URLBuilder.swift
//  Marvelicious
//
//  Created by Tim Studt on 11/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

public class URLBuilder {
    var components: URLComponents!
    public var defaultQueryItems: [URLQueryItem]? {
        didSet {
            guard let defaultQueryItems = defaultQueryItems else { components?.queryItems = nil; return }
            add(queries: defaultQueryItems)
        }
    }
    
    public init(baseURL: URL) {
        components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
    }
    
    @discardableResult
    public func add(path: String) -> URLBuilder {
        var url = components?.url
        url?.appendPathComponent(path)
        if let newPath = url?.path {
            components?.path = newPath
        }
        return self
    }
    
    @discardableResult
    public func add(parameters: Parameters) -> URLBuilder {
        let parametersQueryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return add(queries: parametersQueryItems)
    }

    @discardableResult
    public func add(queries: [URLQueryItem]) -> URLBuilder {
        var currentQuery = components?.queryItems
        currentQuery?.append(contentsOf: queries)
        components?.queryItems = currentQuery ?? queries
        return self
    }
    
    @discardableResult
    public func add(query: URLQueryItem) -> URLBuilder {
        var currentQuery = components?.queryItems
        currentQuery?.append(query)
        components?.queryItems = currentQuery
        return self
    }
    
    public func build() -> URL? {
        return components?.url
    }
}

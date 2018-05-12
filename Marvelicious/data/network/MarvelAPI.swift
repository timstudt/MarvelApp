//
//  MarvelAPI.swift
//  Marvelicious
//
//  Created by Tim Studt on 11/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation
import Keys
import CryptoSwift //for md5 encryption

struct MarvelAPIConfiguration {
    var privatekey: String
    var apikey: String
    let ts = Date().timeIntervalSince1970.description //unique key
    var hash: String { return "\(ts)\(privatekey)\(apikey)".md5() }
    let baseURL: URL = URL(string: "https://gateway.marvel.com/v1/public/")!
    var authHeader: Parameters {
        return ["apikey": apikey,
                "ts": ts,
                "hash": hash]
    }
    
    init(keys: MarveliciousKeys = MarveliciousKeys()) {
        privatekey = keys.marvelPrivateKey
        apikey = keys.marvelApiKey
    }
}

public struct MarvelAPIClient: MarvelAPI {
    public var baseURL: URL
    public var authHeaders: Parameters
    
    init(configuration: MarvelAPIConfiguration = MarvelAPIConfiguration()) {
        self.baseURL = configuration.baseURL
        self.authHeaders = configuration.authHeader
    }
}

public protocol MarvelAPI: API {
    var baseURL: URL { get }
    var authHeaders: Parameters { get }
}

extension MarvelAPI {
    var defaultURLBuilder: URLBuilder {
        let authHeadersQueryItems = authHeaders.map { URLQueryItem(name: $0, value: $1) }
        let builder = URLBuilder(baseURL: baseURL)
        builder
        .defaultQueryItems = authHeadersQueryItems
        return builder
    }
    
    func request(for endpoint: MarvelEndpoint) -> URLRequest {
        let builder = urlRequestBuilder(url: url(for: endpoint))
        return builder
            .add(method: endpoint.method)
            .build()
    }
    
    func url(for endpoint: MarvelEndpoint) -> URL {
        return defaultURLBuilder
            .add(path: endpoint.path)
            .build()!
    }
}

enum MarvelEndpoint {
    case characters(String?)
    
    var path: String {
        switch self {
        case .characters(let id) where id != nil:
            return "characters/\(id!)"
        case .characters:
            return "characters"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .characters:
            return .get
        }
    }
}

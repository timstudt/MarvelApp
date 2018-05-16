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

    func request(for endpoint: MarvelEndpoint) -> URLRequest
}

extension MarvelAPI {
    public var defaultURLBuilder: URLBuilder {
        let authHeadersQueryItems = authHeaders.map { URLQueryItem(name: $0, value: $1) }
        let builder = URLBuilder(baseURL: baseURL)
        builder
        .defaultQueryItems = authHeadersQueryItems
        return builder
    }

    public func request(for endpoint: MarvelEndpoint) -> URLRequest {
        let builder = urlRequestBuilder(url: url(for: endpoint))
        return builder
            .add(method: endpoint.method)
            .build()
    }

    public func url(for endpoint: MarvelEndpoint) -> URL {
        return defaultURLBuilder
            .add(path: endpoint.path)
            .add(parameters: endpoint.parameters)
            .build()!
    }
}

public enum MarvelEndpoint {
    case characters(String?)
    case character(Int)

    var path: String {
        switch self {
        case .characters:
            return "characters"
        case .character(let id):
            return "characters/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .characters,
             .character:
            return .get
        }
    }

    var parameters: Parameters {
        switch self {
        case .characters(let query) where query?.isEmpty == false:
            return ["limit": "30",
                    "nameStartsWith": query!]
        case .characters:
            return ["limit": "30"]
        case .character:
            return [:]
        }

    }
}

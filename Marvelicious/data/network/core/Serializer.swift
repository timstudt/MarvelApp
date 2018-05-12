//
//  Serializer.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

struct Serializer: Serializable { }

protocol Serializable {
    /**
     serializes any generic object which conforms to Decodable
     */
    func serialize<T>(data: Data) throws -> T where T: Decodable
}

extension Serializable {
    /**
     default implementation of serialize generic type from JSON
     */
    func serialize<T>(data: Data) throws -> T where T: Decodable {
        do {
            let decoder = JSONDecoder()
            let response: T = try decoder.decode(T.self, from: data)
            return response
        } catch let err {
            print("Err", err)
            throw NetworkError.decodingFailed
        }
    }
}

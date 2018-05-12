//
//  NetworkError.swift
//  Marvelicious
//
//  Created by Tim Studt on 11/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

/**
 Network Layer error definitions
 */
public enum NetworkError: Error {
    case httpError(Error)
    case decodingFailed
    case missingSerializer
}

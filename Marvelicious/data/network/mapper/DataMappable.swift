//
//  DataMappable.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

protocol DataMappable {
    associatedtype T
    associatedtype U
    func map(_ data: T) -> U
}

extension DataMappable {
    func map(_ data: [T]) -> [U] {
        return data.map { map($0) }
    }    
}

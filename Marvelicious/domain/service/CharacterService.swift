//
//  CharacterService.swift
//  Marvelicious
//
//  Created by Tim Studt on 11/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

public typealias Response<T: Decodable> = (data: [T]?, error: Error?)

public protocol CharacterService {
    func characters(query: String?, completion: @escaping (Response<Character>) -> Void)
}

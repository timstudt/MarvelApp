//
//  CharactersDataMapper.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

struct CharacterDataMapper: DataMappable {
    typealias T = Network.Character
    typealias U = Character
    func map(_ data: T) -> U {
        var mapped = U()
        mapped.name = data.name
        mapped.description = data.description
        if let thumbnailPath = data.thumbnail?.path,
            let thumbnailExt = data.thumbnail?.extension {
            mapped.thumbnail = URL(string: "\(thumbnailPath).\(thumbnailExt)")
        }
        return mapped
    }
    
    func unwrapCharacters(_ wrapper: Network.CharacterDataWrapper?) -> [Network.Character]? {
        //TODO handle pagination
        return wrapper?.data?.results
    }
}

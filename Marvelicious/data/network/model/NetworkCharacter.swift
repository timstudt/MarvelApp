//
//  Character.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

enum Network {}

extension Network {
    struct CharacterDataWrapper: Codable {
        var data: CharacterDataContainer?
    }

    struct CharacterDataContainer: Codable {
        var results: [Character]?
    }

    struct Character: Codable {
        var id: Int?
        var name: String?
        var description: String?
        var thumbnail: Image?
    }

    struct Image: Codable {
        var path: String?
        var `extension`: String?
    }
}

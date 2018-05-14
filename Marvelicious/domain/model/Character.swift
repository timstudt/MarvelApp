//
//  Character.swift
//  Marvelicious
//
//  Created by Tim Studt on 11/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

public struct Character: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: URL?
}

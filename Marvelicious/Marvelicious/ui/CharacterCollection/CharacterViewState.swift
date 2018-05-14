//
//  CharacterCollectionViewState.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

final class CharacterViewState: ViewState<Character> {
    static func loading() -> CharacterViewState {
        return CharacterViewState(isLoading: true, error: nil, data: nil)
    }

    static func hasLoaded(data: [Character]?, error: Error?) -> CharacterViewState {
        return CharacterViewState(isLoading: false, error: error, data: data)
    }
}

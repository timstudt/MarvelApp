//
//  CharacterCollectionViewState.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

final class CharacterCollectionViewState: ViewState<Character> {
    static func loading() -> CharacterCollectionViewState {
        return CharacterCollectionViewState(isLoading: true, error: nil, data: nil)
    }

    static func hasLoaded(data: [Character]?, error: Error?) -> CharacterCollectionViewState {
        return CharacterCollectionViewState(isLoading: false, error: error, data: data)
    }
}

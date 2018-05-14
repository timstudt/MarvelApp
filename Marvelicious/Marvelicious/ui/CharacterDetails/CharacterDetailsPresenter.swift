//
//  CharacterDetailsPresenter.swift
//  Marvelicious
//
//  Created by Tim Studt on 14/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

protocol CharacterDetailsDataSource {
    func load(id: Int)
}

extension CharacterDetailsPresenter {
    static func presenter() -> CharacterDetailsPresenter {
        let presenter = CharacterDetailsPresenter()
        presenter.dataSource = CharacterNetworkService.service()
        return presenter
    }
}

final class CharacterDetailsPresenter: Presenter, CharacterDetailsDataSource {

    typealias Response = (data: [Character]?, error: Error?)

    // MARK: - Module
    var dataSource: CharacterService?

    // MARK: - CharacterCollectionDataSource
    func load(id: Int) {
        userInterface?.render(state: CharacterViewState.loading())

        dataSource?.characters(
            id: id,
            completion: { [weak self] (response: Response) in
                guard let viewState = self?.viewState(for: response) else { return }
                self?.userInterface?.render(state: viewState)
        })
    }

    // MARK: - private methods
    private func viewState(for response: Response) -> CharacterViewState {
        return CharacterViewState
            .hasLoaded(data: response.data,
                       error: response.error)
    }
}

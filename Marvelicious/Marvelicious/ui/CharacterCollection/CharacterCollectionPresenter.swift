//
//  CharacterCollectionPresenter.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

protocol CharacterCollectionDataSource: ViewDataSource {
    func search(query: String)
}

extension CharacterCollectionPresenter {
    static func presenter() -> CharacterCollectionPresenter {
        let presenter = CharacterCollectionPresenter()
        presenter.dataSource = CharacterNetworkService.service()
        return presenter
    }
}

final class CharacterCollectionPresenter: Presenter {
    typealias Response = (data: [Character]?, error: Error?)

    // MARK: - Module
    var dataSource: CharacterService?

    // MARK: - ViewDataSource
    override func loadData() {
        userInterface?.render(state: CharacterCollectionViewState.loading())
        dataSource?.characters(
            query: nil,
            completion: { [weak self] (response: Response)  in
            guard let viewState = self?.viewState(for: response) else { return }
            self?.userInterface?.render(state: viewState)
        })
    }

    func search(query: String) {
        userInterface?.render(state: CharacterCollectionViewState.loading())
        dataSource?.characters(
            query: query,
            completion: { [weak self] (response: Response) in
                guard let viewState = self?.viewState(for: response) else { return }
                self?.userInterface?.render(state: viewState)
        })
    }

    // MARK: - private methods
    private func viewState(for response: Response) -> CharacterCollectionViewState {
        return CharacterCollectionViewState
            .hasLoaded(data: response.data,
                       error: response.error)
    }
}

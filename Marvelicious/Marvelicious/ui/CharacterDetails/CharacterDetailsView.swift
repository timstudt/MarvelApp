//
//  CharacterDetailsView.swift
//  Marvelicious
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

extension CharacterDetailsView {
    /**
     factory method to create CharacterDetailsView instance
     */
    static func view(builder: ModuleBuilder = ModuleBuilder()) -> View {
        let view = self.init()
        return builder
            .add(presenter: CharacterCollectionPresenter.presenter())
            .add(view: view)
            .build()
    }
}

final class CharacterDetailsView: View {
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        dataSource?.loadData()
    }
    
    // MARK: - View override
    override func render(state: ViewStateProtocol) {
        guard let state = state as? CharacterCollectionViewState else { return }
        //TODO error handling
    }
    
    // MARK: - private methods
    private func setupViews() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        guard let margins = view else { return }
        NSLayoutConstraint.activate([
            ])
    }
}

//
//  CharacterCollectionModuleBuilder.swift
//  Marvelicious
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation
import UIKit

final class CharacterCollectionModuleBuilder {
    typealias V = CharacterCollectionView
    typealias R = CharacterCollectionRouter
    typealias P = CharacterCollectionPresenter
    
    var router: R?
    var view: V!
    var presenter: P?
    
    @discardableResult
    func add(view: V) -> Self {
        self.view = view
        return self
    }
    
    @discardableResult
    func add(presenter: P) -> Self {
        self.presenter = presenter
        return self
    }

    @discardableResult
    func add(router: R) -> Self {
        self.router = router
        return self
    }
    
    func build() -> V {
        view.dataSource = presenter
        view.router = router
        router?.viewController = view
        presenter?.userInterface = view
        return view
    }
}

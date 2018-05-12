//
//  CharacterCollectionView.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

extension CharacterCollectionView {
    static func view(builder: ModuleBuilder = ModuleBuilder()) -> View {
        let view = self.init()
        return builder
            .add(presenter: CharacterCollectionPresenter.presenter())
            .add(view: view)
            .build()
    }
}

final class CharacterCollectionView: View {

    let collectionViewDataSource = CollectionViewDataSource<CharacterCollectionViewCellConfigurator>()
    
    // MARK: - subiews
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        dataSource?.loadData()
    }

    // MARK: - View override
    override func render(state: ViewStateProtocol) {
        guard let state = state as? CharacterCollectionViewState else { return }
        collectionViewDataSource.data = state.data
        //TODO error handling
    }
    
    // MARK: - private methods
    private func setupViews() {
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        setupConstraints()
        collectionViewDataSource.collectionView = collectionView
    }

    private func setupConstraints() {
        guard let margins = view else { return }
        NSLayoutConstraint.activate([
            collectionView
                .leadingAnchor
                .constraint(equalTo: margins.leadingAnchor),
            collectionView
                .trailingAnchor
                .constraint(equalTo: margins.trailingAnchor),
            collectionView
                .topAnchor
                .constraint(equalTo: margins.topAnchor),
            collectionView
                .bottomAnchor
                .constraint(equalTo: margins.bottomAnchor)
        ])
    }
}

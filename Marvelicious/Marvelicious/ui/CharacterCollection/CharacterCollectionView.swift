//
//  CharacterCollectionView.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

extension CharacterCollectionView {
    static func view(builder: CharacterCollectionModuleBuilder = CharacterCollectionModuleBuilder()) -> CharacterCollectionView {
        let view = self.init()
        return builder
            .add(presenter: CharacterCollectionPresenter.presenter())
            .add(view: view)
            .add(router: CharacterCollectionRouter())
            .build()
    }
}

final class CharacterCollectionView: View {
    
    var router: CharacterCollectionRoutable?
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
        title = "Marvel"

        navigationController?.hidesBarsOnSwipe = true
        
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        setupConstraints()
        collectionViewDataSource.collectionView = collectionView
        collectionView.delegate = self
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

extension CharacterCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = collectionViewDataSource.data?[indexPath.row] else { return }
        router?.route(to: .characterDetails(character))
    }
}

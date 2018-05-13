//
//  CollectionViewDataSource.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

/**
 Generic CollectionViewDataSource implements UICollectionViewDataSource for simple collectionViews with one cell type and one array of data; uses a UICollectionViewCellConfigurable configurator to configure cells
 */
public class CollectionViewDataSource<CellConfiguratorType: NSObject>:
    NSObject,
    UICollectionViewDataSource
    where CellConfiguratorType: UICollectionViewCellConfigurable {

    var data: [CellConfiguratorType.Model]? {
        didSet { collectionView?.reloadData() }
    }

    var cellConfigurator: CellConfiguratorType?
    weak var collectionView: UICollectionView? {
        didSet { setup() }
    }

    init(cellConfigurator: CellConfiguratorType? = .init()) {
        self.cellConfigurator = cellConfigurator
        super.init()
    }

    func setup() {
        collectionView?.register(
            CellConfiguratorType.Cell.self,
            forCellWithReuseIdentifier: CellConfiguratorType.reuseIdentifier)
        collectionView?.dataSource = self
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellConfiguratorType.reuseIdentifier,
            for: indexPath)
        if let cell = cell as? CellConfiguratorType.Cell,
            let item = data?[indexPath.row] {
            cellConfigurator?.configure(cell, with: item)
        } else {
            assert(false, "unregisted cell type - \(cell)")
        }
        return cell
    }
}

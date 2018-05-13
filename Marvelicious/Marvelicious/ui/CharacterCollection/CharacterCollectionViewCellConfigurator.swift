//
//  CharacterCollectionViewCellConfigurator.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit
import AlamofireImage

/**
 Configurator for character collection view cell using the Character model
 */
final class CharacterCollectionViewCellConfigurator: NSObject, UICollectionViewCellConfigurable {
    typealias Cell = CharacterCollectionViewCell
    typealias Model = Character

    func configure(_ cell: Cell, with model: Model) {
        cell.titleLabel.text = model.name
        cell.imageView.setImage(
            url: model.thumbnail,
            placeholderImage: UIImage(named: "marvel"))
    }
}

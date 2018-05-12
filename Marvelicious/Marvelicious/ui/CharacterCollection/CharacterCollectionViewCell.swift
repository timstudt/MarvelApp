//
//  CharacterCollectionViewCell.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    // MARK: - subviews
    let titleLabel = UILabel()
    let imageView = UIImageView()
    
    private struct localConstants {
        static let margins: UIEdgeInsets = .zero
        static let font = UIFont.systemFont(ofSize: 10)
        static let textColor = UIColor.white
        static let labelBackgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    //MARK: - view overrides
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - update
    func update(title: String?, imageURL: URL?) {
        titleLabel.text = title
//        imageView.u
    }
    
    //MARK: - setup
    private func setupViews() {
        contentView.layoutMargins = localConstants.margins
        setupBorder()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        titleLabel.textAlignment = .center
        titleLabel.font = localConstants.font
        titleLabel.textColor = localConstants.textColor
        titleLabel.backgroundColor = localConstants.labelBackgroundColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        setupConstraints()
    }
    
    private func setupConstraints() {
        let margins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            imageView
                .leadingAnchor
                .constraint(equalTo: margins.leadingAnchor),
            imageView
                .trailingAnchor
                .constraint(equalTo: margins.trailingAnchor),
            imageView
                .topAnchor
                .constraint(equalTo: margins.topAnchor),
            imageView
                .bottomAnchor
                .constraint(equalTo: margins.bottomAnchor),
            titleLabel
                .leadingAnchor
                .constraint(equalTo: margins.leadingAnchor),
            titleLabel
                .centerXAnchor
                .constraint(equalTo: margins.centerXAnchor),
            titleLabel
                .heightAnchor
                .constraint(equalToConstant: 15),
            titleLabel
                .bottomAnchor
                .constraint(equalTo: margins.bottomAnchor)
           ])
    }
    
    private func setupBorder() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
    }
}

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
    static func view(character: Character, builder: ModuleBuilder = ModuleBuilder()) -> View {
        let view = self.init()
        view.character = character
        //For now use simple view with character item, no need for presenter, etc
        return builder
            .add(view: view)
            .build()
    }
}

final class CharacterDetailsView: View {

    // MARK: - models
    var character: Character?

    // MARK: - subviews
    weak var imageView: UIImageView!
    weak var descriptionLabel: UILabel!

    private struct localConstants {
        static let space: CGFloat = 8.0
        static let font = UIFont.systemFont(ofSize: 16)
        static let textColor = UIColor.darkText
        static let numberOfLines = 0
        static let backgroundColor = UIColor.white
    }

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        update(from: character)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    // MARK: - View override
    override func render(state: ViewStateProtocol) {
    }

    func update(from character: Character?) {
        title = character?.name
        if let thumbnail = character?.thumbnail {
            imageView.setImage(url: thumbnail, placeholderImage: nil)
        }
        descriptionLabel.text = character?.description
    }

    // MARK: - private methods
    private func setupViews() {
        view.backgroundColor = .white

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        self.imageView = imageView

        let descriptionLabel = UILabel()
        descriptionLabel.font = localConstants.font
        descriptionLabel.textColor = localConstants.textColor
        descriptionLabel.numberOfLines = localConstants.numberOfLines
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel

        setupConstraints()
    }

    private func setupConstraints() {
        let margins = view.safeAreaLayoutGuide
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
            descriptionLabel
                .leadingAnchor
                .constraint(equalTo: margins.leadingAnchor,
                            constant: localConstants.space),
            descriptionLabel
                .trailingAnchor
                .constraint(equalTo: margins.trailingAnchor,
                            constant: localConstants.space),
            descriptionLabel
                .topAnchor
                .constraint(equalTo: imageView.bottomAnchor,
                            constant: localConstants.space),
            descriptionLabel
                .bottomAnchor
                .constraint(lessThanOrEqualTo: margins.bottomAnchor)
            ])
    }
}

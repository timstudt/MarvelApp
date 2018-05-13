//
//  CollectionViewHeader.swift
//  Marvelicious
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

extension CollectionViewHeader {
    func update(isLoading: Bool, hasData: Bool, error: Error? = nil) {
        var text: String?
        if isLoading {
            text = "Loading.."
        } else if hasData {
            text = nil
        } else if let error = error {
            text = error.localizedDescription
        } else {
            text = "No results"
        }
        titleLabel.text = text
    }
}
public class CollectionViewHeader: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setupConstraints()
    }

    private func setupConstraints() {
        let margins = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel
                .leadingAnchor
                .constraint(greaterThanOrEqualTo: margins.leadingAnchor),
            titleLabel
                .centerXAnchor
                .constraint(equalTo: margins.centerXAnchor),
            titleLabel
                .topAnchor
                .constraint(equalTo: margins.topAnchor),
            titleLabel
                .bottomAnchor
                .constraint(equalTo: margins.bottomAnchor)
            ])
    }
}

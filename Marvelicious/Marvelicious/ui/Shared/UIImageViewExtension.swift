//
//  UIImageViewExtension.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    func setImage(url: URL?,
                  placeholderImage: UIImage? = nil,
                  completion: ((UIImage?) -> Void)? = nil) {
        if let url = url {
            af_setImage(
                withURL: url,
                placeholderImage: placeholderImage,
                completion: { response in
                    completion?(response.value)
            })
        } else {
            image = placeholderImage
        }
    }
}

//
//  CharacterCollectionRouter.swift
//  Marvelicious
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

enum CharacterRoute {
    case characterDetails(Int)
}

protocol CharacterCollectionRoutable {
    func route(to: CharacterRoute)
}

class CharacterCollectionRouter: CharacterCollectionRoutable {
    weak var viewController: UIViewController?
    
    func route(to route: CharacterRoute) {
        let nextView = view(for: route)
        viewController?.show(nextView, sender: nil)
    }
    
    func view(for route: CharacterRoute) -> UIViewController {
        switch route {
        case .characterDetails(let characterId):
            let view = CharacterDetailsView.view(characterId: characterId)
            return view
        }
    }
}

//TODO custom transition
//extension CharacterCollectionRouter: UIViewControllerTransitioningDelegate {
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return nil
//    }
//
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return nil
//    }
//}

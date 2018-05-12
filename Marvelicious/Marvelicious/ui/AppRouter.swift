//
//  Router.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

struct AppRouter {
    enum Route {
        case characterCollection
        case characterDetails(Character)
    }
    
    static let shared = AppRouter()
    
    weak var current: UIViewController?
    
    static func route(to: Route) -> UIViewController {
        var router = shared
        return router.route(to: to)
    }
    
    mutating func route(to: Route) -> UIViewController {
        var nextView: UIViewController!
        switch to {
        case .characterCollection:
            nextView = CharacterCollectionView.view()
        case .characterDetails(let character):
//            nextView =
            break
        }
        current = nextView
        return nextView
    }
}

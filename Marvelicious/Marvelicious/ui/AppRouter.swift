//
//  Router.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import UIKit

class AppRouter {
    enum Route {
        case characters
    }
    
    weak var window: UIWindow?
    weak var current: UIViewController?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    @discardableResult
    func route(to route: Route) -> Bool {
        guard let window = window else {
            assertionFailure("unexpected found window nil")
            return false
        }
        
        if let nextView = viewController(for: route) {
            window.rootViewController = UINavigationController(rootViewController: nextView)
            window.makeKeyAndVisible()
            current = nextView
        } else {
            current = nil
        }
        
        return current != nil
    }
    
    func viewController(for route: Route) -> UIViewController? {
        var viewController: UIViewController?
        switch route {
        case .characters:
            viewController = CharacterCollectionView.view()
        }
        return viewController
    }
    
}

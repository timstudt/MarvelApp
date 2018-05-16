//
//  CharacterCollectionRouterTests.swift
//  MarveliciousTests
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import XCTest
@testable import Marvelicious

class MockViewController: UIViewController {
    var didCallShow = false

    override func show(_ vc: UIViewController, sender: Any?) {
        didCallShow = true
    }
}

class CharacterCollectionRouterTests: XCTestCase {
    var sut: CharacterCollectionRouter!

    override func setUp() {
        super.setUp()
        sut = CharacterCollectionRouter()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testRoute() {
        let mockViewController = MockViewController()
        sut.viewController = mockViewController
        XCTAssertFalse(mockViewController.didCallShow)
        sut.route(to: .characterDetails(12))
        XCTAssertTrue(mockViewController.didCallShow)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

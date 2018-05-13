//
//  CharacterDetailsViewTests.swift
//  MarveliciousTests
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import XCTest
@testable import Marvelicious

class CharacterDetailsViewTests: XCTestCase {
    var sut: CharacterDetailsView!

    override func setUp() {
        super.setUp()
        sut = CharacterDetailsView(nibName: nil, bundle: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewLoading() {
        XCTAssertFalse(sut.isViewLoaded, "")
    }

    func testSubviewContentNil() {
        _ = sut.view
        XCTAssertNil(sut.imageView.image, "")
        XCTAssertNil(sut.descriptionLabel.text, "")
    }

    func testSubviewContent() {
        let dataLoader = DataLoader()
        try! dataLoader.load(filename: "character", fileType: "json")
        sut.character = dataLoader.parse()
        _ = sut.view
        XCTAssertNotNil(sut.title, "")
        XCTAssertNotNil(sut.descriptionLabel.text, "")
        XCTAssertEqual(sut.title, "Hulk")
        XCTAssertEqual(sut.descriptionLabel.text, "Caught in a gamma bomb explosion while trying to save the life of a teenager, Dr. Bruce Banner was transformed into the incredibly powerful creature called the Hulk. An all too often misunderstood hero, the angrier the Hulk gets, the stronger the Hulk gets.")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

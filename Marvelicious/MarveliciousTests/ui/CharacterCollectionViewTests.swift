//
//  CharacterCollectionViewTests.swift
//  MarveliciousTests
//
//  Created by Tim Studt on 14/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import XCTest
@testable import Marvelicious

class StubCharacterCollectionPresenter: Presenter, CharacterCollectionDataSource {
    var didCallDeinit = false
    var didCallSearch = false
    var didCallLoadData = false
    var testData: Any?

    deinit {
        didCallDeinit = true
    }

   func search(query: String) {
        didCallSearch = true
    }

    func loadData() {
        didCallLoadData = true
    }
}

class CharacterCollectionViewTests: XCTestCase {

    var sut: CharacterCollectionView!

    override func setUp() {
        super.setUp()
        sut = CharacterCollectionView(nibName: nil, bundle: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewLoading() {
        XCTAssertFalse(sut.isViewLoaded, "")
    }

    func testSubviewSetup() {
        _ = sut.view
        XCTAssertEqual(sut.title, "Marvel")
        XCTAssertNotNil(sut.collectionView, "")
        XCTAssertNotNil(sut.searchController.searchBar, "")

        XCTAssertNotNil(sut.collectionView, "")
        XCTAssertNotNil(sut.collectionView.delegate, "")
        XCTAssertNotNil(sut.collectionView.dataSource, "")
        XCTAssertNotNil(sut.searchController.searchResultsUpdater, "")
    }

    func testLoadData() {
        let stubPresenter = StubCharacterCollectionPresenter()
        sut.dataSource = stubPresenter
        _ = sut.view
        XCTAssertTrue(stubPresenter.didCallLoadData, "")
        XCTAssertFalse(stubPresenter.didCallSearch, "")
   }

    func testRenderData() {
        let dataLoader = DataLoader()
        try! dataLoader.load(filename: "character", fileType: "json")
        let character: Marvelicious.Character = dataLoader.parse()!

        _ = sut.view

        let state = CharacterViewState.hasLoaded(data: [character], error: nil)
        sut.render(state: state)

        XCTAssertEqual(sut.collectionView.numberOfSections, 1)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

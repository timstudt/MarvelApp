//
//  CharacterCollectionPresenterTests.swift
//  MarveliciousTests
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import XCTest
@testable import Marvelicious

class MockCharacterService: CharacterService {

    var didCallLoadCharacters = false
    
    var testData:[Marvelicious.Character]?
    var testError: Error?
    
    func characters(query: String?, completion: @escaping ((data: [Marvelicious.Character]?, error: Error?)) -> Void) {
        didCallLoadCharacters = true
        completion((testData, testError))
    }
}

class MockUserInterface: PresenterOutput {

    var didCallRender = false

    var error: Error?
    var isLoading = false
    
    func render(state: ViewStateProtocol) {
        didCallRender = true
        error = state.error
        isLoading = state.isLoading
    }
}

class CharacterCollectionPresenterTests: XCTestCase {
    
    var sut: CharacterCollectionPresenter!
    
    override func setUp() {
        super.setUp()
        sut = CharacterCollectionPresenter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSetupNil() {
        XCTAssertNil(sut.dataSource)
        XCTAssertNil(sut.userInterface)
    }
    
    func testSetup() {
        sut = CharacterCollectionPresenter.presenter()
        XCTAssertNotNil(sut.dataSource)
        XCTAssertNil(sut.userInterface)
    }

    func testDatasourceCall() {
        let mockDataSource = MockCharacterService()
        sut.dataSource = mockDataSource
        let mockInterface = MockUserInterface()
        sut.userInterface = mockInterface
 
        XCTAssertFalse(mockInterface.didCallRender)
        XCTAssertFalse(mockDataSource.didCallLoadCharacters)
        
        sut.loadData()
        XCTAssertTrue(mockInterface.didCallRender)
        XCTAssertTrue(mockDataSource.didCallLoadCharacters)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

//
//  CharacterDetailsPresenterTests.swift
//  MarveliciousTests
//
//  Created by Tim Studt on 14/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import XCTest
@testable import Marvelicious

class CharacterDetailsPresenterTests: XCTestCase {
    
    var sut: CharacterDetailsPresenter!
    
    override func setUp() {
        super.setUp()
        sut = CharacterDetailsPresenter()
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
        sut = CharacterDetailsPresenter.presenter()
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
        XCTAssertFalse(mockDataSource.didCallLoadCharactersById)

        sut.load(id: 123)
        XCTAssertTrue(mockInterface.didCallRender)
        XCTAssertFalse(mockDataSource.didCallLoadCharacters)
        XCTAssertTrue(mockDataSource.didCallLoadCharactersById)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

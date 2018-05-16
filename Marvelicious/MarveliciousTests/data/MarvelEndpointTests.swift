//
//  MarvelEndpointTests.swift
//  MarveliciousTests
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import XCTest
@testable import Marvelicious

class MarvelEndpointTests: XCTestCase {
    var sut: MarvelEndpoint!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCharactersNilQuery() {
        sut = MarvelEndpoint.characters(nil)
        XCTAssertEqual(sut.method.rawValue, "GET")
        XCTAssertEqual(sut.path, "characters")
        XCTAssertEqual(sut.parameters, ["limit": "30"])
    }

    func testCharactersEmptyQuery() {
        sut = MarvelEndpoint.characters("")
        XCTAssertEqual(sut.method.rawValue, "GET")
        XCTAssertEqual(sut.path, "characters")
        XCTAssertEqual(sut.parameters, ["limit": "30"])
    }

    func testCharactersQuery() {
        sut = MarvelEndpoint.characters("hello")
        XCTAssertEqual(sut.method.rawValue, "GET")
        XCTAssertEqual(sut.path, "characters")
        XCTAssertEqual(sut.parameters, ["limit": "30", "nameStartsWith": "hello"])
    }

    func testCharacterId() {
        sut = MarvelEndpoint.character(1234)
        XCTAssertEqual(sut.method.rawValue, "GET")
        XCTAssertEqual(sut.path, "characters/1234")
        XCTAssertEqual(sut.parameters, [:])
    }

 func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

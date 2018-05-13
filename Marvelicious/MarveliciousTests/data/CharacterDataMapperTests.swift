//
//  CharacterDataMapperTests.swift
//  MarveliciousDataTests
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import XCTest
@testable import Marvelicious

class CharacterDataMapperTests: XCTestCase {
    var sut: CharacterDataMapper!
    let dataLoader = DataLoader()

    override func setUp() {
        super.setUp()
        sut = CharacterDataMapper()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testMapItemEmpty() {
        let data = Network.Character()
        let mappedData = sut.map(data)
        XCTAssertNil(mappedData.description)
        XCTAssertNil(mappedData.thumbnail)
        XCTAssertNil(mappedData.name)
    }

    func testMapItem() {
        let data = Network.Character(name: "Test", description: "testing", thumbnail: Network.Image(path: "file", extension: "jpg"))
        let mappedData = sut.map(data)
        XCTAssertEqual(mappedData.description, "testing")
        XCTAssertNotNil(mappedData.thumbnail)
        XCTAssertEqual(mappedData.name, "Test")
        XCTAssertEqual(mappedData.thumbnail?.pathExtension, "jpg")
        XCTAssertEqual(mappedData.thumbnail?.path, "file.jpg")
    }

    func testJSONCodable() {
        try! dataLoader.load(filename: "charactersWrapper", fileType: "json")
        let data: Network.CharacterDataWrapper? = dataLoader.parse()
        XCTAssertNotNil(data)

        let characters = sut.unwrapCharacters(data)
        XCTAssertNotNil(characters)
        XCTAssertTrue(characters?.count == 1, "unexpected amount of characters")
        let hulk: Network.Character! = characters?.first
        XCTAssertEqual(hulk?.name, "Hulk")
        XCTAssertEqual(hulk?.thumbnail?.path, "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/538615ca33ab0")
        XCTAssertEqual(hulk?.thumbnail?.extension, "jpg")

        let domainCharacters: [Marvelicious.Character] = sut.map(characters!)
        XCTAssertTrue(domainCharacters.count == 1, "unexpected amount of characters")

        let character: Marvelicious.Character! = domainCharacters.first
        XCTAssertEqual(character?.name, "Hulk")
        XCTAssertEqual(character?.thumbnail?.absoluteString, "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/538615ca33ab0.jpg")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

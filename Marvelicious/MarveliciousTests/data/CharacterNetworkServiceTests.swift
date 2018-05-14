//
//  CharacterNetworkServiceTests.swift
//  MarveliciousTests
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import XCTest
@testable import Marvelicious

class MockConnector: NetworkProvider, ImageDownloadRequestable {
    var logger: NetworkLoggable?
    var didCallDeinit = false
    var didCallSendData = false
    var didCallSendGenericData = false
    var didCallDownloadData = false
    var testData: Any?

    deinit {
        didCallDeinit = true
    }

    func send(request: URLRequest,
              completion: @escaping (((data: Data?, error: Error?)) -> Void))
        -> NetworkTask {
            didCallSendData = true
            completion((nil, nil))
            return MockNetworkTask()
    }

    func send<T>(request: URLRequest, serializer: Serializable?, completion: @escaping ((data: T?, error: Error?)) -> Void) -> NetworkTask where T: Decodable {
        didCallSendGenericData = true
        completion((testData as? T, nil))
        return MockNetworkTask()
    }

    func download(request: URLRequest,
                  progress: @escaping (Progress) -> Void,
                  completion: @escaping ((data: Data?, error: Error?)) -> Void)
        -> NetworkTask {
            didCallDownloadData = true
            completion((nil, nil))
            return MockNetworkTask()
    }
}

class MockNetworkTask: NetworkTask {
    func cancel() { }
    func resume() { }
    func suspend() { }
}

struct MockAPI: API {
    var baseURL: URL { return URL(string: "http://www.google.com")! }
}

class MockMarvelAPIClient: MarvelAPI {
    var authHeaders: Parameters = ["mock_key": "mockYou"]
    var didCallRequest = false

    var baseURL: URL { return URL(string: "http://www.google.com")! }

    func request(for endpoint: MarvelEndpoint) -> URLRequest {
        didCallRequest = true
        return URLRequest(url: baseURL)
    }
}

class CharacterNetworkServiceTests: XCTestCase {
    var sut: CharacterNetworkService!

    override func setUp() {
        super.setUp()
        sut = CharacterNetworkService(networkProvider: nil, api: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testDefaultInit() {
        XCTAssertNil(sut.networkProvider)
        XCTAssertNil(sut.api)
    }

    func testFactoryInit() {
        sut = CharacterNetworkService.service()
        XCTAssertNotNil(sut.networkProvider)
        XCTAssertNotNil(sut.api)
    }

    func testNetworkProvider() {
        let networkProvider = MockConnector()
        sut = CharacterNetworkService(networkProvider: networkProvider, api: nil)
        XCTAssertNotNil(sut.networkProvider)
        XCTAssertFalse(networkProvider.didCallSendData, "unexpectedly called send data")

        sut.characters(query: nil, completion: { (data, error) in
            XCTAssertNil(data, "load data unexpected error in response")
            XCTAssertNil(error)
        })
        XCTAssertFalse(networkProvider.didCallSendData, "unexpectedly called send data")
    }

    func testNetworkProviderAndAPI() {
        let networkProvider = MockConnector()
        sut = CharacterNetworkService.service()
        sut.networkProvider = networkProvider
        XCTAssertNotNil(sut.networkProvider)
        XCTAssertNotNil(sut.api)
        XCTAssertFalse(networkProvider.didCallSendGenericData, "unexpectedly called send data")

        sut.characters(query: nil, completion: { (data, error) in
            XCTAssertNil(data, "load data unexpected error in response")
            XCTAssertNil(error)
        })
        XCTAssertTrue(networkProvider.didCallSendGenericData, "unexpectedly not called send data")
    }

    func testNetworkTestData() {
        let networkProvider = MockConnector()
        let dataLoader = DataLoader()
        try! dataLoader.load(filename: "charactersWrapper", fileType: "json")
        let testData: Network.CharacterDataWrapper = dataLoader.parse()!
        networkProvider.testData =  testData as Any

        sut = CharacterNetworkService.service()
        sut.networkProvider = networkProvider
        XCTAssertNotNil(sut.networkProvider)
        XCTAssertNotNil(sut.api)
        XCTAssertFalse(networkProvider.didCallSendGenericData, "unexpectedly called send data")

        sut.characters(query: nil, completion: { (data, error) in
            XCTAssertNotNil(data, "load data unexpected error in response")
            XCTAssertNil(error)
            XCTAssertTrue(data?.count == 1, "unexpected amount of characters")

            let character: Marvelicious.Character! = data?.first
            XCTAssertEqual(character?.name, "Hulk")
            XCTAssertEqual(character?.thumbnail?.absoluteString, "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/538615ca33ab0.jpg")
        })
        XCTAssertTrue(networkProvider.didCallSendGenericData, "unexpectedly not called send data")
    }

   func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

//
//  CharacterNetworkService.swift
//  Marvelicious
//
//  Created by Tim Studt on 11/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

public extension CharacterNetworkService {
    static func service() -> CharacterNetworkService {

        return CharacterNetworkService(
            networkProvider: AlamofireNetworkProvider(),
            api: MarvelAPIClient()
        )
    }
}

/**
 NetworkService that implements CharacterService protocol; using MarvelAPIClient
 */
public class CharacterNetworkService: NetworkService<MarvelAPIClient>, CharacterService {

    let serializer = Serializer()
    var characterMapper = CharacterDataMapper()

    weak var currentTask: NetworkTask?

    /**
     fetch characters which names start with query
     - parameter query:
     - parameter completion: handler that takes a response
     */
    public func characters(query: String?, completion: @escaping (Response<Character>) -> Void) {
        guard let request = api?.request(for: .characters(query)) else {
            completion((nil, nil)); return
        }
        handle(request: request, completion: completion)
    }

    /**
     fetch characters by id
     - parameter id: character id
     - parameter completion: handler that takes a response
     */
    public func characters(id: Int, completion: @escaping ((data: [Character]?, error: Error?)) -> Void) {
        guard let request = api?.request(for: .character(id)) else {
            completion((nil, nil)); return
        }
        handle(request: request, completion: completion)
     }

    private func handle(request: URLRequest, completion: @escaping ((data: [Character]?, error: Error?)) -> Void) {
        currentTask?.cancel()

        currentTask = networkProvider?
            .send(
                request: request,
                serializer: serializer,
                completion: { [weak self] (response: NetworkResponse<Network.CharacterDataWrapper>) in
                    var data: [Character]?
                    if let characters: [Network.Character] = self?.characterMapper.unwrapCharacters(response.data) {
                        let mappedCharacters: [Character]? = self?.characterMapper.map(characters)
                        data = mappedCharacters
                    }
                    completion((data, response.error))
            })
    }

}

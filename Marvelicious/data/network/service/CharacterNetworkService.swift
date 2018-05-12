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
            networkProvider: AlamofireConnector(),
            api: MarvelAPIClient()
        )
    }
}

public class CharacterNetworkService: NetworkService<MarvelAPIClient>, CharacterService {

    let serializer = Serializer()
    var characterMapper = CharacterDataMapper()
    
    private weak var currentTask: NetworkTask?
    
    public func characters(query: String?, completion: @escaping (Response<Character>) -> Void) {
        guard let request = api?.request(for: .characters(query)) else {
            completion((nil, nil)); return
        }
        
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

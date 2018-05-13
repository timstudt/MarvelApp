//
//  DataLoader.swift
//  MarveliciousTests
//
//  Created by Tim Studt on 13/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

class DataLoader {
    var data: Data?
    
    func load(filename: String, fileType: String) throws {
        guard let filePath = Bundle(for: type(of: self)).path(forResource: filename, ofType:fileType) else {
            print("DefaultUnwrapper: invalid resource name: \(filename)")
            throw(NSError())
        }
        
        do{
            let data = try Data.init(contentsOf: URL(fileURLWithPath: filePath), options: .uncached)
            self.data = data
        }
        catch let error{
            print(error)
        }
    }
    
    func parse<T: Decodable>() -> T? {
        guard let data = data else { return nil }
        return DataParser.parseJSON(from: data)
    }
 }

struct DataParser {
    static func parseJSON<T: Decodable>(from data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let response: T = try decoder.decode(T.self, from: data)
            return response
        } catch let err {
            print("Err", err)
            return nil
        }
        return nil
    }
}

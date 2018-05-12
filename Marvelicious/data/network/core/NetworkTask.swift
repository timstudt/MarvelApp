//
//  NetworkTask.swift
//  Marvelicious
//
//  Created by Tim Studt on 11/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

protocol NetworkTask: class {
    func cancel()
    func resume()
    func suspend()
}

//
//  NetworkProvider.swift
//  Marvelicious
//
//  Created by Tim Studt on 12/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Foundation

public typealias NetworkResponse<T: Decodable> = (data: T?, error: Error?)

/**
 Base Network provider, 
 */
protocol NetworkProvider: DataRequestable {
    var logger: NetworkLoggable? { get set }
}

protocol DataRequestable {
//    @discardableResult
//    func send(
//        request: URLRequest,
//        completion: @escaping (NetworkResponse<Data>) -> Void)
//        -> NetworkTask
    
    @discardableResult
    func send<T: Decodable>(
        request: URLRequest,
        serializer: Serializable?,
        completion: @escaping (NetworkResponse<T>) -> Void)
        -> NetworkTask
}

protocol ImageDownloadRequestable {
    @discardableResult
    func download(
        request: URLRequest,
        progress: @escaping (Progress) -> Void,
        completion: @escaping (NetworkResponse<Data>) -> Void)
        -> NetworkTask
}

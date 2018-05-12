//
//  Connector.swift
//  Marvelicious
//
//  Created by Tim Studt on 11/05/2018.
//  Copyright © 2018 Tim Studt. All rights reserved.
//

import Alamofire

/**
 Network provider implemented with Alamofire
 */
struct AlamofireConnector: NetworkProvider {
    
    var logger: NetworkLoggable?
    let sessionManager = Alamofire.SessionManager.default
    
    init(logger: NetworkLoggable? = NetworkLogger()) {
        self.logger = logger
    }
    
    @discardableResult
    func send<T>(request: URLRequest,
                 serializer: Serializable?,
                 completion: @escaping (NetworkResponse<T>) -> Void)
        -> NetworkTask where T: Decodable {
            return sessionManager
                .request(request)
                .validate()
                .responseSerialization(
                    serializer: serializer,
                    logger: logger,
                    completionHandler: completion)
    }
}

extension AlamofireConnector: ImageDownloadRequestable {
    func download(request: URLRequest,
                  progress: @escaping (Progress) -> Void,
                  completion: @escaping (NetworkResponse<Data>) -> Void)
        -> NetworkTask {
            
            return sessionManager
                .request(request)
                .validate()
                .responseDataMapper(
                    logger: logger,
                    completionHandler: completion)
    }
}

//MARK: - Alamofire extensions for serializing JSON responses to Decodable values
extension Alamofire.DataRequest: NetworkTask {
    /**
     default response mapper
     - parameter logger: logs network response
     - parameter completionHandler: handler that takes NetworkResponse<Data> parameter
     - return Self: chainable
     */
    @discardableResult
    func responseDataMapper(
        logger: NetworkLoggable? = nil,
        completionHandler: @escaping (NetworkResponse<Data>) -> Void)
        -> Self {
            return
                log(logger)
                .responseData { (response) in
                    let mappedResponse = self.map(response: response)
                    completionHandler(mappedResponse)
            }
    }
    
    /**
     generic response mapper
     - parameter serializer: serializes response data
     - parameter logger: logs network response
     - parameter completionHandler: handler that takes generic NetworkResponse<T> parameter
     - return Self: chainable
     */
    @discardableResult
    func responseSerialization<T>(
        serializer: Serializable?,
        logger: NetworkLoggable? = nil,
        completionHandler: @escaping (NetworkResponse<T>) -> Void)
        -> Self where T : Decodable {
            return
                log(logger)
                .responseData(completionHandler: { (response) in
                    let networkResponse: NetworkResponse<T> =
                        self.parse(
                            response: response,
                            serializer: serializer)
                    completionHandler(networkResponse)
            })
    }
    
    //MARK: - Logging
    func log(_ logger:NetworkLoggable? = nil) -> Self {
        logger?.log(response: self.response)
        return self
    }
    
    //MARK: - Mapping
    private func map<T: Decodable>(response: Alamofire.DataResponse<T>)
        -> NetworkResponse<T> {
            return (response.value, response.error)
    }
    
    //MARK: - Parsing
    /**
     parse Alamofire Data Response to Network response with decoded value T
     - parameter response: Alamofire.DataResponse<Data>
     - parameter serializer: serializes response.value to return value of type T
     - return NetworkResponse: parsed response with value T
     */
    private func parse<T>(response: Alamofire.DataResponse<Data>,
                           serializer: Serializable?)
        -> NetworkResponse<T> where T: Decodable {
            var data: T?
            var error: Error?
            switch response.result {
            case .success(let value):
                do {
                    guard let serializer = serializer else { return NetworkResponse(nil, NetworkError.missingSerializer) }
                    let serializedData: T = try serializer.serialize(data: value)
                    data = serializedData
                } catch let err {
                    print("NetworkProvider Error", err)
                    error = err
                }
            case .failure(let err):
                error = err
            }
            return NetworkResponse(data, error)
    }
}

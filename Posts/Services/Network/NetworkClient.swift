//
//  NetworkClient.swift
//  Posts
//
//  Created by Diogo on 19/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

public protocol NetworkClientProvider {
    func submit(_ request: NetworkRequest) -> Single<NetworkResponse>
}

public final class NetworkClient: NetworkClientProvider {
    public enum Method: String {
        case get
        case post
        case patch
        case put
        case delete
    }

    public enum Error: Swift.Error {
        case unknown
    }

    private let urlSession: URLSessionProvider

    public static func defaultURLSessionFactory() -> URLSessionProvider {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        return URLSession(configuration: configuration)
    }

    public init(urlSession: URLSessionProvider = NetworkClient.defaultURLSessionFactory()) {
        self.urlSession = urlSession
    }

    // MARK: - NetworkClientProvider

    public func submit(_ request: NetworkRequest) -> Single<NetworkResponse> {
        return Single.create { single in
            log(request: request.urlRequest)
            let task = self.urlSession
                .dataTask(with: request.urlRequest, completionHandler: { data, response, error in
                    guard let response = response as? HTTPURLResponse else {
                        let error = error ?? Error.unknown
                        Log.error(error)
                        single(.error(error))

                        return
                    }

                    let data = data ?? Data()
                    log(response: response, data: data)
                    single(.success(NetworkResponse(statusCode: response.statusCode, data: data)))
                })

            task.resume()

            return Disposables.create(with: task.cancel)
        }
    }
}

// MARK: - Logging

private func log(request: URLRequest) {
    guard let method = request.httpMethod, let url = request.url else {
        return
    }

    let body: String = request.httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? "<no body>"
    Log.debug("\(method)ing \(body) to \(url)")
}

private func log(response: HTTPURLResponse, data: Data) {
    guard let url = response.url else {
        return
    }

    let loggableData = String(data: data, encoding: .utf8) ?? "<empty body>"
    Log.debug("Received \(loggableData) (\(response.statusCode)) for \(url)")
}

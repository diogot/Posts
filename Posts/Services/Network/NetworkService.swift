//
//  NetworkService.swift
//  Posts
//
//  Created by Diogo on 19/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

public protocol NetworkServiceProvider {
    func submit<T: Decodable>(_ request: NetworkRequest) -> Single<T>
}

public final class NetworkService: NetworkServiceProvider {
    private let networkClient: NetworkClientProvider
    private let headersProvider: NetworkServiceHeadersProvider
    private let encodingProvider: NetworkServiceEncodingProvider
    private let urlProvider: NetworkServiceURLProvider
    private let validationProvider: NetWorkServiceResponseValidationProvider
    private let decodingProvider: NetworkServiceDecodingProvider
    private let backgroundScheduler: SchedulerType

    public init(networkClient: NetworkClientProvider,
                headersProvider: NetworkServiceHeadersProvider,
                encodingProvider: NetworkServiceEncodingProvider,
                urlProvider: NetworkServiceURLProvider,
                validationProvider: NetWorkServiceResponseValidationProvider,
                decodingProvider: NetworkServiceDecodingProvider) {
        self.networkClient = networkClient
        self.headersProvider = headersProvider
        self.encodingProvider = encodingProvider
        self.urlProvider = urlProvider
        self.validationProvider = validationProvider
        self.decodingProvider = decodingProvider

        backgroundScheduler = SerialDispatchQueueScheduler(qos: .userInitiated,
                                                           internalSerialQueueName: "com.diogot.posts-NetworkService")
    }

    public func submit<T: Decodable>(_ request: NetworkRequest) -> Single<T> {
        return createClientRequest(from: request)
            .subscribeOn(backgroundScheduler)
            .flatMap(networkClient.submit)
            .observeOn(backgroundScheduler)
            .flatMap(validationProvider.parse)
            .flatMap(decodingProvider.decode)
            .observeOn(MainScheduler.instance)
    }

    private func createClientRequest(from request: NetworkRequest) -> Single<NetworkClientRequest> {
        let headers = headersProvider.headers(for: request)
        let body = encodingProvider.body(for: request)
        let url = urlProvider.url(for: request)

        return Single.zip(url, body, headers).map { url, body, headers -> NetworkClientRequest in
            NetworkClientRequest(method: request.method, url: url, body: body, headers: headers)
        }
    }
}

extension NetworkService {
    convenience init() {
        self.init(networkClient: NetworkClient(),
                  headersProvider: NetworkServiceHeadersBuilder(),
                  encodingProvider: NetworkServiceEncoder(),
                  urlProvider: NetworkServiceURLBuilder(),
                  validationProvider: NetworkServiceValidator(),
                  decodingProvider: NetworkServiceDecoder())
    }
}

public protocol NetworkServiceHeadersProvider {
    typealias Header = [String: String]
    func headers(for request: NetworkRequest) -> Single<NetworkServiceHeadersProvider.Header>
}

public protocol NetworkServiceEncodingProvider {
    func body(for request: NetworkRequest) -> Single<Data?>
}

public protocol NetworkServiceURLProvider {
    func url(for request: NetworkRequest) -> Single<URL>
}

public protocol NetWorkServiceResponseValidationProvider {
    func parse(_ response: NetworkClientResponse) -> Single<Data>
}

public protocol NetworkServiceDecodingProvider {
    func decode<T: Decodable>(_ data: Data) -> Single<T>
}

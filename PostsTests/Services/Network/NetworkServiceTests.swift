//
//  NetworkServiceTests.swift
//  PostsTests
//
//  Created by Diogo on 20/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Nimble
@testable import Posts
import RxBlocking
import RxSwift
import XCTest

final class NetworkServiceTests: XCTestCase {

    private var service: NetworkService!
    private var client: FakeNetworkClient!
    private var headersProvider: FakeHeadersProvider!
    private var encoder: FakeEncoder!
    private var urlProvider: FakeURLProvider!
    private var validator: FakeValidator!
    private var decoder: FakeDecoder!
    private var request = NetworkRequest(resource: .init("/user"), method: .get)

    override func setUp() {
        super.setUp()
        headersProvider = FakeHeadersProvider()
        client = FakeNetworkClient()
        encoder = FakeEncoder()
        urlProvider = FakeURLProvider()
        validator = FakeValidator()
        decoder = FakeDecoder()
        service = NetworkService(networkClient: client, headersProvider: headersProvider,
                                 encodingProvider: encoder, urlProvider: urlProvider,
                                 validationProvider: validator, decodingProvider: decoder)
    }

    func testSuccessRequest() {
        let result: MaterializedSequenceResult<Model> =
            service.submit(request).toBlocking().materialize()

        expect(result.error).to(beNil())

        expect(self.headersProvider.headersCalls) == 1
        expect(self.headersProvider.recievedRequests.map { $0.resource }) == [request.resource]

        expect(self.encoder.bodyCalls) == 1
        expect(self.encoder.recievedRequests.map { $0.resource }) == [request.resource]

        expect(self.urlProvider.urlCalls) == 1
        expect(self.urlProvider.recievedRequests.map { $0.resource }) == [request.resource]

        expect(self.client.submitCalls) == 1
        expect(self.client.recievedRequests) == [NetworkClientRequest(method: .get, url: urlProvider.defaultURL)]

        expect(self.validator.parseCalls) == 1
        expect(self.validator.recievedResponses) == [client.defaultResponse]

        expect(self.decoder.decodeCalls) == 1
        expect(self.decoder.recievedData) == [Data()]

        expect(result.elements) == [decoder.defaultResponse]
    }
}

private final class FakeNetworkClient: NetworkClientProvider {
    private(set) var submitCalls = 0
    private(set) var recievedRequests = [NetworkClientRequest]()
    let defaultResponse = NetworkClientResponse(statusCode: 200, data: Data())
    lazy var submitResult = Single.just(defaultResponse)
    func submit(_ request: NetworkClientRequest) -> Single<NetworkClientResponse> {
        submitCalls += 1
        recievedRequests.append(request)
        return submitResult
    }
}

private final class FakeHeadersProvider: NetworkServiceHeadersProvider {
    private(set) var headersCalls = 0
    private(set) var recievedRequests = [NetworkRequest]()
    var headersResponse: Single<Header> = .just([:])
    func headers(for request: NetworkRequest) -> Single<Header> {
        headersCalls += 1
        recievedRequests.append(request)
        return headersResponse
    }
}

private final class FakeEncoder: NetworkServiceEncodingProvider {
    private(set) var bodyCalls = 0
    private(set) var recievedRequests = [NetworkRequest]()
    var bodyResponse: Single<Data?> = .just(nil)
    func body(for request: NetworkRequest) -> Single<Data?> {
        bodyCalls += 1
        recievedRequests.append(request)
        return bodyResponse
    }
}

private final class FakeURLProvider: NetworkServiceURLProvider {
    private(set) var urlCalls = 0
    private(set) var recievedRequests = [NetworkRequest]()
    let defaultURL = URL(string: "https://diogot.com")!
    lazy var urlResponse: Single<URL> = .just(defaultURL)
    func url(for request: NetworkRequest) -> Single<URL> {
        urlCalls += 1
        recievedRequests.append(request)
        return urlResponse
    }
}

private final class FakeValidator: NetWorkServiceResponseValidationProvider {
    private(set) var parseCalls = 0
    private(set) var recievedResponses = [NetworkClientResponse]()
    var parseReponse: Single<Data>?
    func parse(_ response: NetworkClientResponse) -> Single<Data> {
        parseCalls += 1
        recievedResponses.append(response)
        return parseReponse ?? .just(response.data)
    }
}

private final class FakeDecoder: NetworkServiceDecodingProvider {
    private(set) var decodeCalls = 0
    private(set) var recievedData = [Data]()
    let defaultResponse = Model(name: "Joe Doe", age: 42)
    lazy var decodeResponse = Single.just(defaultResponse)
    func decode<T: Decodable>(_ data: Data) -> Single<T> {
        decodeCalls += 1
        recievedData.append(data)
        return decodeResponse as? Single<T> ?? .error(TestError.decoderError)
    }
}

private enum TestError: Error {
    case decoderError
}

private struct Model: Decodable, Equatable {
    let name: String
    let age: Int
}

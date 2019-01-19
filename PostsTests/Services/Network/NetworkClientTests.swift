//
//  NetworkClientTests.swift
//  PostsTests
//
//  Created by Diogo on 19/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Nimble
@testable import Posts
import XCTest
import RxBlocking

final class NetworkClientTests: XCTestCase {

    private var client: NetworkClient!
    private var session: FakeURLSession!
    private var url: URL!

    override func setUp() {
        super.setUp()
        session = FakeURLSession()
        url = URL(string: "https://diogot.com")!
        client = NetworkClient(urlSession: session)
    }

    func testSubmit() {
        let request = NetworkClientRequest(method: .get, url: url)
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let expectedResponse = NetworkClientResponse(statusCode: 200, data: Data())

        let result = client.submit(request).toBlocking().materialize()

        expect(self.session.dataTaskCalls) == 1
        expect(result.error).to(beNil())
        expect(result.elements.first) == expectedResponse
    }

    func testSubmitError() {
        let request = NetworkClientRequest(method: .get, url: url)
        let error = NSError(domain: "test", code: 123, userInfo: nil)
        session.error = error

        let result = client.submit(request).toBlocking().materialize()

        expect(self.session.dataTaskCalls) == 1
        expect(result.error).to(matchError(error))
        expect(result.elements).to(beEmpty())
    }

    func testSubmitInconsistentHandlerCall() {
        let request = NetworkClientRequest(method: .get, url: url)

        let result = client.submit(request).toBlocking().materialize()

        expect(self.session.dataTaskCalls) == 1
        expect(result.error).to(matchError(NetworkClient.Error.unknown))
        expect(result.elements).to(beEmpty())
    }
}

private final class FakeURLSession: URLSessionProvider {
    private(set) var dataTaskCalls = 0
    var data: Data?
    var response: URLResponse?
    var error: Error?
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCalls += 1
        completionHandler(data, response, error)
        return FakeDataTask()
    }
}

private final class FakeDataTask: URLSessionDataTask {
    override func resume() {}
    override func cancel() {}
}

//
//  NetworkClientRequestTests.swift
//  PostsTests
//
//  Created by Diogo on 19/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Nimble
@testable import Posts
import XCTest

final class NetworkClientRequestTests: XCTestCase {

    private var request: NetworkClientRequest!
    private var url: URL!
    private var data: Data!
    private var headers: [String: String]!

    override func setUp() {
        super.setUp()
        url = URL(string: "http://diogot.com")!
        data = "data".data(using: .utf8)!
        headers = ["header1": "fine", "header2": "go"]
        request = NetworkClientRequest(method: .get, url: url, body: data, headers: headers)
    }

    func testMethod() {
        expect(self.request.method) == .get
    }

    func testURL() {
        expect(self.request.url) == url
    }

    func testBody() {
        expect(self.request.body) == data
    }

    func testHeaders() {
        expect(self.request.headers) == headers
    }

    func testURLRequest() {
        let urlRequest = request.urlRequest
        expect(urlRequest.url) == url
        expect(urlRequest.httpMethod) == "GET"
        expect(urlRequest.httpBody) == data
        let headers = urlRequest.allHTTPHeaderFields
        expect(headers?["header1"]) == "fine"
        expect(headers?["header2"]) == "go"
    }
}

//
//  NetworkServiceValidatorTests.swift
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

class NetworkServiceValidatorTests: XCTestCase {

    private var validator: NetworkServiceValidator!

    override func setUp() {
        super.setUp()

        validator = NetworkServiceValidator()
    }

    func testValidResponse() {
        let response = NetworkClientResponse(statusCode: 200, data: Data())
        let result = validator.parse(response).toBlocking().materialize()
        expect(result.error).to(beNil())
        expect(result.elements) == [Data()]
    }

    func testInvalidResponse() {
        let response = NetworkClientResponse(statusCode: 404, data: Data())
        let result = validator.parse(response).toBlocking().materialize()
        expect(result.error).to(matchError(NetworkServiceError.requestFailed(response: response)))
        expect(result.elements).to(beEmpty())
    }
}

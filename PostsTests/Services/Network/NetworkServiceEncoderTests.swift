//
//  NetworkServiceEncoderTests.swift
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

class NetworkServiceEncoderTests: XCTestCase {

    private var encoder: NetworkServiceEncoder!

    override func setUp() {
        super.setUp()

        encoder = NetworkServiceEncoder()
    }

    func testEncodeModel() {
        let model = Model(name: "Joe Doe", age: 42)
        let encoded = try! JSONEncoder().encode(model)
        let request = NetworkRequest(resource: .init(rawValue: ".some"), method: .get, data: model)
        let result = encoder.body(for: request).toBlocking().materialize()
        expect(result.error).to(beNil())
        expect(result.elements.first) == encoded
    }

    func testEncodeNilData() {
        let request = NetworkRequest(resource: .init(rawValue: ".some"), method: .get, data: nil)
        let result = encoder.body(for: request).toBlocking().materialize()
        expect(result.error).to(beNil())
        expect(result.elements) == [nil]
    }

    func testEncodingError() {
        let model = Model(name: "Joe Doe", age: Double.nan)
        let request = NetworkRequest(resource: .init(rawValue: ".some"), method: .get, data: model)
        let result = encoder.body(for: request).toBlocking().materialize()
        expect(result.elements).to(beEmpty())
        expect(result.error).toNot(beNil())
    }
}

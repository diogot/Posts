//
//  NetworkServiceDecoderTests.swift
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

class NetworkServiceDecoderTests: XCTestCase {

    private var decoder: NetworkServiceDecoder!

    override func setUp() {
        super.setUp()

        decoder = NetworkServiceDecoder()
    }

    func testSuccessDecoding() {
        let expectedModel = Model(name: "Joe Doe", age: 42)
        let encoded = try! JSONEncoder().encode(expectedModel)
        let result: MaterializedSequenceResult<Model> =
            decoder.decode(encoded).toBlocking().materialize()
        expect(result.error).to(beNil())
        expect(result.elements) == [expectedModel]
    }

    func testFailedDecoding() {
        let result: MaterializedSequenceResult<Model> =
            decoder.decode(Data()).toBlocking().materialize()
        expect(result.error).toNot(beNil())
        expect(result.elements).to(beEmpty())
    }
}

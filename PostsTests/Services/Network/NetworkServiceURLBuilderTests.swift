//
//  NetworkServiceURLBuilderTests.swift
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

class NetworkServiceURLBuilderTests: XCTestCase {

    private var builder: NetworkServiceURLBuilder!

    override func setUp() {
        super.setUp()

        builder = NetworkServiceURLBuilder()
    }

    func testBuildValidURL() {
        let request = NetworkRequest(resource: .init(rawValue: "test"),
                                     method: .get,
                                     parameters: ["par1": "ok", "par2": "nope"])
        let expectedURL = URL(string: "https://jsonplaceholder.typicode.com/test?par1=ok&par2=nope")!
        let restult = builder.url(for: request).toBlocking().materialize()

        expect(restult.error).to(beNil())
        expect(restult.elements) == [expectedURL]
    }
}

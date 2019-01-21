//
//  UsersAPITests.swift
//  PostsTests
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Nimble
@testable import Posts
import RxBlocking
import RxSwift
import XCTest

class UsersAPITests: XCTestCase {

    func testUsers() {
        let netework = FakeNetworkService<[User]>()
        let api = UsersAPI(network: netework)
        let expectedModel = [ModelFactory().user()]
        netework.submitResponse = .just(expectedModel)

        let results = api.users().toBlocking().materialize()
        expect(results.error).to(beNil())
        expect(results.elements) == [expectedModel]
        expect(netework.submitCalls) == 1
        expect(netework.recievedRequests).to(haveCount(1))
        let request = netework.recievedRequests.first
        expect(request?.resource.rawValue) == "/users"
        expect(request?.method) == .get
        expect(request?.parameters).to(beNil())
        expect(request?.data).to(beNil())
    }

    func testUser() {
        let netework = FakeNetworkService<User>()
        let api = UsersAPI(network: netework)
        let expectedModel = ModelFactory().user()
        netework.submitResponse = .just(expectedModel)

        let results = api.user(with: 1).toBlocking().materialize()
        expect(results.error).to(beNil())
        expect(results.elements) == [expectedModel]
        expect(netework.submitCalls) == 1
        expect(netework.recievedRequests).to(haveCount(1))
        let request = netework.recievedRequests.first
        expect(request?.resource.rawValue) == "/users/1"
        expect(request?.method) == .get
        expect(request?.parameters).to(beNil())
        expect(request?.data).to(beNil())
    }
}

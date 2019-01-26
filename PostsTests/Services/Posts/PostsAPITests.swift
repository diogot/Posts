//
//  PostsAPITests.swift
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

class PostsAPITests: XCTestCase {

    func testPosts() {
        let netework = FakeNetworkService<[Post]>()
        let api = PostsAPI(network: netework)
        let expectedPosts = [ModelFactory().post()]
        netework.submitResponse = .just(expectedPosts)

        let results = api.posts().toBlocking().materialize()
        expect(results.error).to(beNil())
        expect(results.elements) == [expectedPosts]
        expect(netework.submitCalls) == 1
        expect(netework.recievedRequests).to(haveCount(1))
        let request = netework.recievedRequests.first
        expect(request?.resource.rawValue) == "/posts"
        expect(request?.method) == .get
        expect(request?.parameters).to(beNil())
        expect(request?.data).to(beNil())
    }

    func testComments() {
        let netework = FakeNetworkService<[Comment]>()
        let api = PostsAPI(network: netework)
        let expectedComments = [ModelFactory().comment()]
        netework.submitResponse = .just(expectedComments)

        let results = api.comments(of: 1).toBlocking().materialize()
        expect(results.error).to(beNil())
        expect(results.elements) == [expectedComments]
        expect(netework.submitCalls) == 1
        expect(netework.recievedRequests).to(haveCount(1))
        let request = netework.recievedRequests.first
        expect(request?.resource.rawValue) == "/comments"
        expect(request?.method) == .get
        expect(request?.parameters) == ["postId": "1"]
        expect(request?.data).to(beNil())
    }}

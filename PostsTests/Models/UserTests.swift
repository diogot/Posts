//
//  UserTests.swift
//  PostsTests
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Nimble
@testable import Posts
import XCTest

class UserTests: XCTestCase {
    func testDecodable() {
        let bundle = Bundle(for: type(of: self))
        let json = try! Data(contentsOf: bundle.url(forResource: "post", withExtension: "json")!)

        var post: Post?
        expect {
            post = try JSONDecoder().decode(Post.self, from: json)
        }.toNot(throwError())

        expect(post?.id.rawValue) == 1
        expect(post?.userId.rawValue) == 10
        expect(post?.title) == "some title"
        expect(post?.body) == "some body"
    }
}

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
        let json = ModelFactory().json(of: .user)

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

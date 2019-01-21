//
//  PostTests.swift
//  PostsTests
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Nimble
@testable import Posts
import XCTest

final class PostTests: XCTestCase {
    func testDecodable() {
        let json = ModelFactory().json(of: .post)

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

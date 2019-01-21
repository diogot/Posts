//
//  CommentTests.swift
//  PostsTests
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Nimble
@testable import Posts
import XCTest

class CommentTests: XCTestCase {
    func testDecodable() {
        let bundle = Bundle(for: type(of: self))
        let json = try! Data(contentsOf: bundle.url(forResource: "comment", withExtension: "json")!)

        var user: Comment?
        expect {
            user = try JSONDecoder().decode(Comment.self, from: json)
        }.toNot(throwError())

        expect(user?.id.rawValue) == 1
        expect(user?.postId.rawValue) == 10
        expect(user?.name) == "some name"
        expect(user?.email) == "Eliseo@gardner.biz"
        expect(user?.body) == "some body"
    }
}

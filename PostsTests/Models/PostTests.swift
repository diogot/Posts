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

class PostTests: XCTestCase {
    func testDecodable() {
        let bundle = Bundle(for: type(of: self))
        let json = try! Data(contentsOf: bundle.url(forResource: "user", withExtension: "json")!)

        var user: User?
        expect {
            user = try JSONDecoder().decode(User.self, from: json)
        }.toNot(throwError())

        expect(user?.id.rawValue) == 1
        expect(user?.name) == "Leanne Graham"
        expect(user?.username) == "Bret"
        expect(user?.email) == "Sincere@april.biz"
        expect(user?.website) == URL(string: "hildegard.org")!
    }
}

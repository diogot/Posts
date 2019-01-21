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

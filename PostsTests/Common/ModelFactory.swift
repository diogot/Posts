//
//  ModelFactory.swift
//  PostsTests
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
@testable import Posts

final class ModelFactory {
    let bundle: Bundle
    let decoder = JSONDecoder()

    init() {
        bundle = Bundle(for: type(of: self))
    }

    func json(of model: Models) -> Data {
        return try! Data(contentsOf: bundle.url(forResource: model.rawValue, withExtension: "json")!)
    }

    func comment() -> Comment {
        return try! decoder.decode(Comment.self, from: json(of: .comment))
    }

    func post() -> Post {
        return try! decoder.decode(Post.self, from: json(of: .post))
    }

    func user() -> User {
        return try! decoder.decode(User.self, from: json(of: .user))
    }

    enum Models: String {
        case comment
        case post
        case user
    }
}

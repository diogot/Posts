//
//  User.swift
//  Posts
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import Tagged

struct User: Decodable, Equatable {
    let id: Id
    let name: String
    let username: String
    let email: String
    let website: URL

    typealias Id = Tagged<User, Int>
}

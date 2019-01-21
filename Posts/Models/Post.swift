//
//  Post.swift
//  Posts
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import Tagged

struct Post: Decodable {
    let id: Id
    let userId: User.Id
    let title: String
    let body: String

    typealias Id = Tagged<Post, Int>
}

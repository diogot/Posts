//
//  Comment.swift
//  Posts
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import Tagged

struct Comment: Decodable, Equatable {
    let id: Id
    let postId: Post.Id
    let name: String
    let email: String
    let body: String

    typealias Id = Tagged<Comment, Int>
}

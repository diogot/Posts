//
//  PostsService.swift
//  Posts
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

protocol PostsServiceProvider {
    func posts() -> Observable<[Post]>
    func comments(of post: Post) -> Observable<[Comment]>
    func author(of post: Post) -> Observable<User>
}

final class PostsService: PostsServiceProvider {

    private let postsAPI: PostsAPIProvider
    private let usersAPI: UsersAPIProvider

    init(postsAPI: PostsAPIProvider = PostsAPI(), usersAPI: UsersAPIProvider = UsersAPI()) {
        self.postsAPI = postsAPI
        self.usersAPI = usersAPI
    }

    func posts() -> Observable<[Post]> {
        return postsAPI.posts().asObservable()
    }

    func comments(of post: Post) -> Observable<[Comment]> {
        return postsAPI.comments(of: post.id).asObservable()
    }

    func author(of post: Post) -> Observable<User> {
        return usersAPI.user(with: post.userId).asObservable()
    }
}

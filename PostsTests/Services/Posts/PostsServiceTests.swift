//
//  PostsServiceTests.swift
//  PostsTests
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Nimble
@testable import Posts
import RxBlocking
import RxSwift
import XCTest

final class PostsServiceTests: XCTestCase {
    private var service: PostsService!
    private var postsAPI: FakePostsAPI!
    private var userAPI: FakeUsersAPI!

    override func setUp() {
        super.setUp()

        postsAPI = FakePostsAPI()
        userAPI = FakeUsersAPI()
        service = PostsService(postsAPI: postsAPI, usersAPI: userAPI)
    }

    func testPosts() {
        let result = service.posts().toBlocking().materialize()
        expect(result.error).to(beNil())
        expect(result.elements).to(haveCount(1))
        expect(result.elements) == [postsAPI.defaultPosts]
        expect(self.postsAPI.postsCalls) == 1
    }

    func testComments() {
        let post = ModelFactory().post()
        let result = service.comments(of: post).toBlocking().materialize()
        expect(result.error).to(beNil())
        expect(result.elements).to(haveCount(1))
        expect(result.elements) == [postsAPI.defaultComments]
        expect(self.postsAPI.commentsCalls) == 1
        expect(self.postsAPI.commentsRecievedPostsIds) == [post.id]
    }

    func testAuthor() {
        let post = ModelFactory().post()
        let result = service.author(of: post).toBlocking().materialize()
        expect(result.error).to(beNil())
        expect(result.elements).to(haveCount(1))
        expect(result.elements) == [userAPI.defaultUser]
        expect(self.userAPI.userCalls) == 1
        expect(self.userAPI.userRecievedIds) == [post.userId]
    }
}

private final class FakePostsAPI: PostsAPIProvider {
    private(set) var postsCalls = 0
    let defaultPosts = [ModelFactory().post()]
    lazy var postsResult = Single.just(defaultPosts)
    func posts() -> Single<[Post]> {
        postsCalls += 1
        return postsResult
    }

    private(set) var commentsCalls = 0
    private(set) var commentsRecievedPostsIds = [Post.Id]()
    let defaultComments = [ModelFactory().comment()]
    lazy var commentsResult = Single.just(defaultComments)
    func comments(of postId: Post.Id) -> Single<[Comment]> {
        commentsCalls += 1
        commentsRecievedPostsIds.append(postId)
        return commentsResult
    }
}

private final class FakeUsersAPI: UsersAPIProvider {
    private(set) var usersCalls = 0
    let defaultUsers = [ModelFactory().user()]
    lazy var usersResult = Single.just(defaultUsers)
    func users() -> Single<[User]> {
        usersCalls += 1
        return usersResult
    }

    private(set) var userCalls = 0
    private(set) var userRecievedIds = [User.Id]()
    let defaultUser = ModelFactory().user()
    lazy var userResult = Single.just(defaultUser)
    func user(with id: User.Id) -> Single<User> {
        userCalls += 1
        userRecievedIds.append(id)
        return userResult
    }
}

//
//  PostsAPI.swift
//  Posts
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

protocol PostsAPIProvider {
    func posts() -> Single<[Post]>
    func comments(of postId: Post.Id) -> Single<[Comment]>
}

final class PostsAPI: PostsAPIProvider {

    private let network: NetworkServiceProvider

    init(network: NetworkServiceProvider = NetworkService()) {
        self.network = network
    }

    func posts() -> Single<[Post]> {
        let request = NetworkRequest(resource: .posts, method: .get)
        return network.submit(request)
    }

    func comments(of postId: Post.Id) -> Single<[Comment]> {
        let request = NetworkRequest(resource: .comments, method: .get, parameters: ["postId": String(postId.rawValue)])
        return network.submit(request)
    }
}

private extension NetworkRequest.Resource {
    static let posts = NetworkRequest.Resource(rawValue: "/posts")
    static let comments = NetworkRequest.Resource("/comments")
}

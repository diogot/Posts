//
//  UsersAPI.swift
//  Posts
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

protocol UsersAPIProvider {
    func users() -> Single<[User]>
    func user(with id: User.Id) -> Single<User>
}

final class UsersAPI: UsersAPIProvider {

    private let network: NetworkServiceProvider

    init(network: NetworkServiceProvider = NetworkService()) {
        self.network = network
    }

    func users() -> Single<[User]> {
        let request = NetworkRequest(resource: .users, method: .get)
        return network.submit(request)
    }

    func user(with id: User.Id) -> Single<User> {
        let request = NetworkRequest(resource: .user(with: id.rawValue), method: .get)
        return network.submit(request)
    }
}

private extension NetworkRequest.Resource {
    static let users = NetworkRequest.Resource(rawValue: "/users")
    static func user(with id: Int) -> NetworkRequest.Resource {
        return NetworkRequest.Resource("/users/\(id)")
    }
}

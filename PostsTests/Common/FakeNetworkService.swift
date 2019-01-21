//
//  FakeNetworkService.swift
//  PostsTests
//
//  Created by Diogo on 21/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import Posts
import RxSwift

final class FakeNetworkService<Element>: NetworkServiceProvider {
    private(set) var submitCalls = 0
    private(set) var recievedRequests = [NetworkRequest]()
    var submitResponse: Single<Element>?
    func submit<T: Decodable>(_ request: NetworkRequest) -> Single<T> {
        submitCalls += 1
        recievedRequests.append(request)
        return submitResponse as? Single<T> ?? .error(Error.undefinedType)
    }

    enum Error: Swift.Error {
        case undefinedType
    }
}

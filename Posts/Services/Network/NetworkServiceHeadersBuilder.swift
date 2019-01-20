//
//  NetworkServiceHeadersBuilder.swift
//  Posts
//
//  Created by Diogo on 20/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkServiceHeadersBuilder: NetworkServiceHeadersProvider {
    func headers(for request: NetworkRequest) -> Single<NetworkServiceHeadersProvider.Header> {
        return .just([:])
    }
}

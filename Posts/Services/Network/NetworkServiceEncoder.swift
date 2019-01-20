//
//  NetworkServiceEncoder.swift
//  Posts
//
//  Created by Diogo on 20/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkServiceEncoder: NetworkServiceEncodingProvider {
    func body(for request: NetworkRequest) -> Single<Data?> {
        guard let data = request.data else {
            return .just(nil)
        }

        do {
            let body = try JSONEncoder().encode(EncodableBox(value: data))
            return Single.just(body)
        } catch {
            return Single.error(error)
        }
    }

    private struct EncodableBox: Encodable {
        let value: Encodable

        func encode(to encoder: Encoder) throws {
            return try value.encode(to: encoder)
        }
    }
}

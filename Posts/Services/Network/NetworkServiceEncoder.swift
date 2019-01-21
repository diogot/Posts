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
        return .just {
            guard let data = request.data else {
                return nil
            }

            return try JSONEncoder().encode(EncodableBox(value: data))
        }
    }

    private struct EncodableBox: Encodable {
        let value: Encodable

        func encode(to encoder: Encoder) throws {
            return try value.encode(to: encoder)
        }
    }
}

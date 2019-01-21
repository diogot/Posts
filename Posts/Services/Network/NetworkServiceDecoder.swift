//
//  NetworkServiceDecoder.swift
//  Posts
//
//  Created by Diogo on 20/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkServiceDecoder: NetworkServiceDecodingProvider {
    func decode<T: Decodable>(_ data: Data) -> Single<T> {
        return .just {
            try JSONDecoder().decode(T.self, from: data)
        }
    }
}

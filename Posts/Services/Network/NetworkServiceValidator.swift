//
//  NetworkServiceValidator.swift
//  Posts
//
//  Created by Diogo on 20/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkServiceValidator: NetWorkServiceResponseValidationProvider {
    func parse(_ response: NetworkClientResponse) -> Single<Data> {
        guard 200 ..< 300 ~= response.statusCode else {
            return .error(NetworkServiceError.requestFailed(response: response))
        }

        return .just(response.data)
    }
}

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
        return .just {
            guard 200 ..< 300 ~= response.statusCode else {
                throw NetworkServiceError.requestFailed(response: response)
            }

            return response.data
        }
    }
}

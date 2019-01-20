//
//  NetworkServiceURLBuilder.swift
//  Posts
//
//  Created by Diogo on 20/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxSwift

final class NetworkServiceURLBuilder: NetworkServiceURLProvider {
    func url(for request: NetworkRequest) -> Single<URL> {
        // swiftlint:disable:next force_unwrapping
        let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
            .appendingPathComponent(request.resource.rawValue)

        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = request.parameters?
            .compactMap { URLQueryItem(name: $0.key, value: $0.value) }
            .sorted(by: { $0.name < $1.name })
        guard let url = urlComponents?.url else {
            return .error(NetworkServiceError.invalidURL)
        }

        return .just(url)
    }
}

//
//  NetworkClientRequest.swift
//  Posts
//
//  Created by Diogo on 19/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation

public struct NetworkClientRequest {
    public let method: NetworkClient.Method
    public let url: URL
    public let body: Data?
    public let headers: [String: String]
    public let urlRequest: URLRequest

    public init(method: NetworkClient.Method, url: URL, body: Data? = nil, headers: [String: String] = [:]) {
        self.method = method
        self.url = url
        self.body = body
        self.headers = headers

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue.uppercased()
        urlRequest.httpBody = body
        headers.forEach { (key: String, value: String) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        self.urlRequest = urlRequest
    }
}

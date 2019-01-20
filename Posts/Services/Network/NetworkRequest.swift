//
//  NetworkRequest.swift
//  Posts
//
//  Created by Diogo on 19/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation

public struct NetworkRequest {
    public let resource: Resource
    public let method: NetworkMethod
    public let parameters: Parameters?
    public let data: Encodable?

    init(resource: Resource, method: NetworkMethod,
         parameters: Parameters? = nil, data: Encodable? = nil) {
        self.resource = resource
        self.method = method
        self.parameters = parameters
        self.data = data
    }

    public typealias Parameters = [String: String?]

    public struct Resource: RawRepresentable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(_ rawValue: String) {
            self.init(rawValue: rawValue)
        }
    }
}

extension NetworkRequest: CustomStringConvertible {
    public var description: String {
        return "Task for \(resource)#\(method)"
    }
}

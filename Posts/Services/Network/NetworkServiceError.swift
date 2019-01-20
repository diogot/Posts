//
//  NetworkServiceError.swift
//  Posts
//
//  Created by Diogo on 20/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation

public enum NetworkServiceError: Error {
    case invalidURL
    case requestFailed(response: NetworkClientResponse)
}

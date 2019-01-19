//
//  NetworkResponse.swift
//  Posts
//
//  Created by Diogo on 19/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation

public struct NetworkResponse: Equatable {
    public let statusCode: Int
    public let data: Data
}

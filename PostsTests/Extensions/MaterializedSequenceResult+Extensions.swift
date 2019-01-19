//
//  MaterializedSequenceResult+Extensions.swift
//  PostsTests
//
//  Created by Diogo on 19/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import Foundation
import RxBlocking

extension MaterializedSequenceResult {
    var elements: [T] {
        switch self {
        case .completed(let elements), .failed(let elements, _):
            return elements
        }
    }

    var error: Swift.Error? {
        guard case let .failed(_, error) = self else {
            return nil
        }
        return error
    }
}

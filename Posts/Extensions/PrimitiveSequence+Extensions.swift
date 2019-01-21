//
//  PrimitiveSequence+Extensions.swift
//  Posts
//
//  Created by Diogo on 20/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait {
    static func just(_ block: @escaping () throws -> E) -> Single<E> {
        return create { observer -> Disposable in
            do {
                try observer(.success(block()))
            } catch {
                observer(.error(error))
            }

            return Disposables.create()
        }
    }
}

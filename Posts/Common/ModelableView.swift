//
//  ModelableView.swift
//  Posts
//
//  Created by Diogo on 27/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import UIKit
import RxSwift

protocol ModelableView: class {
    associatedtype ViewModel
    func update(with viewModel: ViewModel)
}

extension ModelableView {
    var viewModel: AnyObserver<ViewModel> {
        return AnyObserver(eventHandler: { [weak self] event in
            guard case let .next(viewModel) = event else {
                return
            }
            self?.update(with: viewModel)
        })
    }
}

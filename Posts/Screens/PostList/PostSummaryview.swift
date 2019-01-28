//
//  PostSummaryView.swift
//  Posts
//
//  Created by Diogo on 27/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import UIKit

final class PostSummaryView: UIView {
    struct ViewModel {
        let title: String
    }

    private let titleView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: topAnchor, constant: Style.grid).isActive = true
        titleView.leftAnchor.constraint(equalTo: leftAnchor, constant: Style.grid).isActive = true
        titleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Style.grid).isActive = true
        titleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Style.grid).isActive = true
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostSummaryView: ModelableView {
    func update(with viewModel: ViewModel) {
        titleView.text = viewModel.title
    }
}

//
//  TableViewCell.swift
//  Posts
//
//  Created by Diogo on 27/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class TableViewCell<View: UIView, ViewModel>: UITableViewCell where View: ModelableView, View.ViewModel == ViewModel {
    let customView: View

    private(set) var disposeBag = DisposeBag()

    override init(style: CellStyle, reuseIdentifier: String?) {
        customView = View()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(customView)
        customView.setContentHuggingPriority(.required, for: .vertical)
        customView.setContentCompressionResistancePriority(.required, for: .vertical)

        customView.translatesAutoresizingMaskIntoConstraints = false

        customView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        customView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        customView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true

        backgroundColor = customView.backgroundColor
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }

    // The final here is necessary and it's related to this https://developer.apple.com/swift/blog/?id=27
    final func update(with viewModel: ViewModel) {
        customView.update(with: viewModel)
    }
}

//
//  UITableView+Extensions.swift
//  Posts
//
//  Created by Diogo on 27/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type,
                                                 for indexPath: IndexPath) -> T {
        let aCell = dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier,
                                        for: indexPath)
        guard let cell = aCell as? T else {
            fatalError("Unable to initialize cell \(String(describing: T.self))")
        }

        return cell
    }
}

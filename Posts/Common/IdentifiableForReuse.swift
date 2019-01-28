//
//  IdentifiableForReuse.swift
//  Posts
//
//  Created by Diogo on 27/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import UIKit

protocol IdentifiableForReuse {
    static var defaultReuseIdentifier: String { get }
}

extension IdentifiableForReuse {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: IdentifiableForReuse {}

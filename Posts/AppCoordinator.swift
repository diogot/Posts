//
//  AppCoordinator.swift
//  Posts
//
//  Created by Diogo on 25/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import UIKit

final class AppCoordinator {

    let navigationController: UINavigationController

    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = PostListViewController()
        viewController.delegate = self
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension AppCoordinator: PostListViewControllerDelegate {
    func didSelect(_ post: Post, in viewController: PostListViewController) {
        let detailViewController = PostDetailViewController(with: post)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}

//
//  PostListViewController.swift
//  Posts
//
//  Created by Diogo on 22/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import RxSwift
import UIKit

protocol PostListViewControllerDelegate: class {
    func didSelect(_ post: Post, in viewController: PostListViewController)
}

final class PostListViewController: UITableViewController {
    weak var delegate: PostListViewControllerDelegate?

    private let dataSource = PostListDataSouce()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.configure(tableView)
        dataSource.delegate = self
        dataSource.loadPosts()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let post = dataSource.post(at: indexPath) else {
            return
        }

        Log.debug(post)
        delegate?.didSelect(post, in: self)
    }
}

extension PostListViewController: PostListDataSouceDelegate {
    func postsDidLoad(in dataSource: PostListDataSouce) {
        tableView.reloadData()
    }
}

//
//  PostListViewController.swift
//  Posts
//
//  Created by Diogo on 22/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import RxCocoa
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
        refreshControl = UIRefreshControl()

        refreshControl?.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        dataSource.configure(tableView)
        dataSource.stateDriver.drive(Binder(self) { me, state in
            switch state {
            case .loading:
                me.refreshControl?.beginRefreshing()
            case .newPosts:
                me.tableView.reloadData()
            case .idle:
                me.refreshControl?.endRefreshing()
            case .error(let error):
                me.refreshControl?.endRefreshing()
                me.display(error)
            }
        }).disposed(by: disposeBag)
        dataSource.loadPosts()
    }

    private func display(_ error: Error) {
        // TODO: better error management
        let done = UIAlertAction(title: "Done", style: .default)
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(done)
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let post = dataSource.post(at: indexPath) else {
            return
        }

        Log.debug(post)
        delegate?.didSelect(post, in: self)
    }

    @objc private func loadPosts() {
        dataSource.loadPosts()
    }
}

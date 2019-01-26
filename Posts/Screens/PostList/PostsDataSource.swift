//
//  PostsDataSource.swift
//  Posts
//
//  Created by Diogo on 24/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import RxSwift
import UIKit

protocol PostListDataSouceDelegate: class {
    func postsDidLoad(in dataSource: PostListDataSouce)
}

final class PostListDataSouce: NSObject {
    private let postsService = PostsService()
    weak var delegate: PostListDataSouceDelegate?

    private var posts = [Post]() {
        didSet {
            delegate?.postsDidLoad(in: self)
        }
    }
    private let disposeBag = DisposeBag()

    func loadPosts() {
        // TODO: loading state
        // TODO: error handling
        postsService.posts()
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
            }, onError: {
                Log.error($0)
            })
            .disposed(by: disposeBag)
    }

    func configure(_ tableView: UITableView) {
        // TODO: custom cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
    }

    func post(at indexPath: IndexPath) -> Post? {
        guard indexPath.section == 0,
            indexPath.row < posts.count else {
                return nil
        }

        return posts[indexPath.row]
    }
}

extension PostListDataSouce: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 0
        }

        return  posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let post = posts[indexPath.row]

        cell.textLabel?.text = post.title

        return cell
    }
}

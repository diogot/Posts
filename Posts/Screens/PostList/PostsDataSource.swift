//
//  PostsDataSource.swift
//  Posts
//
//  Created by Diogo on 24/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class PostListDataSouce: NSObject {
    private let postsService = PostsService()

    var stateDriver: Driver<State> {
        return stateSubject.asDriver(onErrorRecover: { Driver.just(.error($0)) })
    }

    private var stateSubject = BehaviorSubject(value: State.idle)

    enum State {
        case loading
        case newPosts
        case idle
        case error(Error)
    }

    private var posts = [Post]()

    private let disposeBag = DisposeBag()

    func loadPosts() {
        let stateObserver = stateSubject.asObserver()
        postsService.posts()
            .do(onSubscribe: {
                stateObserver.onNext(.loading)
            })
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                stateObserver.onNext(.newPosts)
            }, onError: {
                stateObserver.onNext(.error($0))
            }, onCompleted: {
                stateObserver.onNext(.idle)
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

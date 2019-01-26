//
//  PostDetailViewController.swift
//  Posts
//
//  Created by Diogo on 25/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import UIKit
import RxSwift

final class PostDetailViewController: UIViewController {
    private let post: Post

    private let postsService = PostsService()
    private let disposeBag = DisposeBag()

    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let numberOfCommentsLabel = UILabel()

    init(with post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: create custom view and view models
        let containtView: UIView = self.view
        containtView.backgroundColor = .white

        containtView.addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.centerXAnchor.constraint(equalTo: containtView.centerXAnchor).isActive = true
        authorLabel.topAnchor.constraint(equalTo: containtView.safeAreaLayoutGuide.topAnchor, constant: Style.grid).isActive = true
        authorLabel.leftAnchor.constraint(greaterThanOrEqualTo: containtView.leftAnchor, constant: Style.grid).isActive = true
        authorLabel.rightAnchor.constraint(lessThanOrEqualTo: containtView.rightAnchor, constant: -Style.grid).isActive = true

        containtView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerXAnchor.constraint(equalTo: containtView.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: Style.grid).isActive = true
        descriptionLabel.leftAnchor.constraint(greaterThanOrEqualTo: containtView.leftAnchor, constant: Style.grid).isActive = true
        descriptionLabel.rightAnchor.constraint(lessThanOrEqualTo: containtView.rightAnchor, constant: -Style.grid).isActive = true

        containtView.addSubview(numberOfCommentsLabel)
        numberOfCommentsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfCommentsLabel.centerXAnchor.constraint(equalTo: containtView.centerXAnchor).isActive = true
        numberOfCommentsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Style.grid).isActive = true
        numberOfCommentsLabel.leftAnchor.constraint(greaterThanOrEqualTo: containtView.leftAnchor, constant: Style.grid).isActive = true
        numberOfCommentsLabel.rightAnchor.constraint(lessThanOrEqualTo: containtView.rightAnchor, constant: -Style.grid).isActive = true
        numberOfCommentsLabel.bottomAnchor.constraint(lessThanOrEqualTo: containtView.safeAreaLayoutGuide.bottomAnchor, constant: -Style.grid).isActive = true

        let authorObservable = postsService.author(of: post).map { $0.name }
        let descriptionObservable = Observable.just(post.body)
        let numberOfCommentsObservable = postsService.comments(of: post).map { $0.count }

        // TODO: loading state and error handling
        Observable.combineLatest(authorObservable, descriptionObservable, numberOfCommentsObservable)
            .subscribe(onNext: { [weak self] model in
                let (author, description, numberOfComments) = model
                guard let me = self else {
                    return
                }

                me.authorLabel.text = author
                me.descriptionLabel.text = description
                me.numberOfCommentsLabel.text = String(numberOfComments)
            })
            .disposed(by: disposeBag)
    }
}

// TODO: extract style
enum Style {
    static let grid: CGFloat = 8
}

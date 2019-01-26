//
//  AppDelegate.swift
//  Posts
//
//  Created by Diogo on 19/01/19.
//  Copyright © 2019 Diogo. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let navigationController = UINavigationController()
        window.rootViewController = navigationController

        appCoordinator = AppCoordinator(with: navigationController)

        appCoordinator?.start()

        window.makeKeyAndVisible()

        return true
    }
}

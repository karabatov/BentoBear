//
//  AppDelegate.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 12/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let nav = UINavigationController()

        _ = PostListBuilder(postDetailBuilder: PostDetailBuilder()).make(nav: nav)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }
}


//
//  PostListBuilder.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import UIKit
import BentoKit
import ReactiveSwift

protocol PostListChildBuilders {
    func makePostDetail(presenting: Flow, post: RichPost) -> UIViewController
}

struct PostListBuilder: PostListChildBuilders {
    private let postDetailBuilder: PostDetailBuilder

    init(postDetailBuilder: PostDetailBuilder) {
        self.postDetailBuilder = postDetailBuilder
    }

    func make(nav: UINavigationController?) -> UIViewController {
        let postStore = PostStoreDefaults()
        let viewModel = PostListViewModel(
            store: postStore,
            downloader: PostDownloaderSaving(saveTo: postStore, downloadWith: NetworkDataInternet())
        )

        let viewController = BoxViewController.init(
            viewModel: viewModel,
            renderer: PostListRenderer.self,
            rendererConfig: PostListRenderer.Config(),
            appearance: Property.init(value: PostListRenderer.Appearance())
        )

        nav?.setViewControllers([viewController], animated: false)

        let flowController = PostListFlowController(
            presentationFlow: viewController.navigationFlow,
            presenting: viewController.navigationFlow,
            builders: self
        )

        viewModel.routes
            .observe(on: UIScheduler())
            .observeValues(flowController.handle)

        return viewController
    }

    func makePostDetail(presenting: Flow, post: RichPost) -> UIViewController {
        return postDetailBuilder.make(post: post)
    }
}

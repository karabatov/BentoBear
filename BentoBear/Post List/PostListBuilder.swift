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

struct PostListBuilder {
    func make() -> UIViewController {
        let postStore = PostStoreDefaults()
        let viewModel = PostListViewModel(store: postStore, downloader: PostDownloaderSaving(saveTo: postStore))

        let viewController = BoxViewController.init(
            viewModel: viewModel,
            renderer: PostListRenderer.self,
            rendererConfig: PostListRenderer.Config(),
            appearance: Property.init(value: PostListRenderer.Appearance())
        )

        let flowController = PostListFlowController(
            presentationFlow: viewController.navigationFlow,
            presenting: viewController.navigationFlow
        )

        viewModel.routes
            .observe(on: UIScheduler())
            .observeValues(flowController.handle)

        return viewController
    }
}

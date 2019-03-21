//
//  PostDetailBuilder.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 20/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import UIKit
import BentoKit
import ReactiveSwift

struct PostDetailBuilder {
    func make(post: RichPost) -> UIViewController {
        let viewModel = PostDetailViewModel(post: post)

        let viewController = BoxViewController.init(
            viewModel: viewModel,
            renderer: PostDetailRenderer.self,
            rendererConfig: PostDetailRenderer.Config(),
            appearance: Property.init(value: PostDetailRenderer.Appearance())
        )

        return viewController
    }
}

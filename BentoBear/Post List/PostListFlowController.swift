//
//  PostListFlowController.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import UIKit

final class PostListFlowController {
    private let presentationFlow: Flow
    private let presenting: Flow
    private let builders: PostListChildBuilders

    init(presentationFlow: Flow, presenting: Flow, builders: PostListChildBuilders) {
        self.presentationFlow = presentationFlow
        self.presenting = presenting
        self.builders = builders
    }

    func handle(_ route: PostListViewModel.Route) {
        switch route {
        case .showPost(let post):
            builders.makePostDetail(presenting: presentationFlow, post: post)
                |> presentationFlow.present

        case .showError(let error):
            let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Common.OK".localized(), style: .default, handler: nil)
            alert.addAction(action)

            alert |> presenting.present
        }
    }
}

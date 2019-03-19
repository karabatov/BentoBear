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

    init(presentationFlow: Flow, presenting: Flow) {
        self.presentationFlow = presentationFlow
        self.presenting = presenting
    }

    func handle(_ route: PostListViewModel.Route) {
        switch route {
        case .showPost(_):
            break
        }
    }
}

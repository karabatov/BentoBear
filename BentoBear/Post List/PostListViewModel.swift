//
//  PostListViewModel.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 18/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import BentoKit
import ReactiveSwift
import ReactiveFeedback
import Result

enum PLVMPostsState: Equatable {
    case empty
    case showing([Post])
}

enum PLVMLoadingState: Equatable {
    case idle
    case loading
    case error(String)
}

struct PLVMState: StateType {
    let posts: PLVMPostsState
    let loading: PLVMLoadingState

    static func initial() -> PLVMState {
        return PLVMState(posts: .empty, loading: .idle)
    }
}

enum PLVMEvent: Equatable {
    case ui(PLVMAction)
}

enum PLVMAction: Equatable {
    case selectedPost(index: Int)
}

enum PLVMRoute {
    case showPost
}

final class PostListViewModel: WarBoxViewModel<PLVMAction, PLVMRoute, PLVMEvent, PLVMState> {
    override init() {
        super.init()
    }
}

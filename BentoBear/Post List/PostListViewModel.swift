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

final class PostListViewModel {// : WarBoxViewModel<PostListViewModel.Action, PostListViewModel.Route, PostListViewModel.Event, PostListViewModel.State> {
}

extension PostListViewModel {
    enum PostsState: Equatable {
        case empty
        case showing([Post])
    }

    enum LoadingState: Equatable {
        case idle
        case loading
        case error(String)
    }

    struct State: StateType {
        let posts: PostsState
        let loading: LoadingState

        static func initial() -> PostListViewModel.State {
            return State(posts: .empty, loading: .idle)
        }
    }

    enum Event: Equatable {
        case ui(Action)
    }

    enum Action: Equatable {
        case selectedPost(index: Int)
    }

    enum Route {
        case showPost
    }
}

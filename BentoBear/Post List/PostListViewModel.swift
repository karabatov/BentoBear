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

final class PostListViewModel: BoxViewModel {
    let state: Property<State>
    let routes: Signal<Route, NoError>

    private let (actions, actionsObserver) = Signal<Action, NoError>.pipe()

    init() {
        state = Property(
            initial: .init(posts: .empty, loading: .idle),
            reduce: PostListViewModel.reduce,
            feedbacks: []
        )

        routes = state.signal.skipRepeats().filterMap(PostListViewModel.makeRoute)
    }

    func send(action: Action) {
        actionsObserver.send(value: action)
    }

    private static func reduce(_ state: State, _ event: Event) -> State {
        return state
    }

    private static func makeRoute(_ state: State) -> Route? {
        return nil
    }
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

    struct State: Equatable {
        let posts: PostsState
        let loading: LoadingState
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

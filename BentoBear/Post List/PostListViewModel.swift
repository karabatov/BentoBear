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

/// Display a list of posts.
final class PostListViewModel: BoxViewModel {
    let state: Property<State>
    let routes: Signal<Route, NoError>

    private let (actions, actionsObserver) = Signal<Action, NoError>.pipe()

    init(store: PostStore, downloader: PostDownloader) {
        state = Property(
            initial: .init(posts: .empty, loading: .idle),
            reduce: PostListViewModel.reduce,
            feedbacks: [
                PostListViewModel.whenEmptyIdle(store: store),
                PostListViewModel.whenStartDownloading(downloader: downloader)
            ]
        )

        routes = state.signal.skipRepeats().filterMap(PostListViewModel.makeRoute)
    }

    func send(action: Action) {
        actionsObserver.send(value: action)
    }

    private static func reduce(_ state: State, _ event: Event) -> State {
        switch (state.posts, state.loading, event) {
        // Initial state, posts have been loaded (from disk).
        case (.empty, .idle, .loadedPosts(let posts)):
            return State(posts: .showing(posts), loading: .idle)

        // We have signaled to start downloading, no matter if we have posts or not.
        case (let posts, .idle, .startDownloadingPosts):
            return State(posts: posts, loading: .loading)

        // Switch to idle and display posts or empty state when post loading is finished.
        case (_, .loading, .loadedPosts(let posts)):
            let postState: PostsState
            if posts.isEmpty {
                postState = .empty
            } else {
                postState = .showing(posts)
            }
            return State(posts: postState, loading: .idle)

        default:
            return state
        }
    }

    private static func makeRoute(_ state: State) -> Route? {
        return nil
    }
}

// MARK: Feedbacks

extension PostListViewModel {
    /// Initial state: nothing is loaded from disk or network.
    static func whenEmptyIdle(store: PostStore) -> Feedback<State, Event> {
        return Feedback { state -> SignalProducer<Event, NoError> in
            guard state.posts == .empty && state.loading == .idle else { return .empty }

            let posts = store.loadAllOnDevice()
            if posts.isEmpty {
                return .init(value: .startDownloadingPosts)
            } else {
                return .init(value: .loadedPosts(posts))
            }
        }
    }

    /// Download posts, both from UI and programmatically.
    static func whenStartDownloading(downloader: PostDownloader) -> Feedback<State, Event> {
        return Feedback { state -> SignalProducer<Event, NoError> in
            guard state.loading == .loading else { return .empty }

            let posts = downloader.downloadPosts(overwriteExisting: true)
            return .init(value: .loadedPosts(posts))
        }
    }
}

// MARK: State machine

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
        case loadedPosts([Post])
        case startDownloadingPosts
    }

    enum Action: Equatable {
        case selectedPost(index: Int)
    }

    enum Route {
        case showPost
    }
}

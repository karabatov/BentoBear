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
                PostListViewModel.userActions(actions: actions),
                PostListViewModel.whenEmptyIdle(store: store),
                PostListViewModel.whenStartDownloading(downloader: downloader),
                PostListViewModel.whenPostSelected()
            ]
        )

        routes = state.signal.skipRepeats().filterMap(PostListViewModel.makeRoute)
    }

    func send(action: Action) {
        actionsObserver.send(value: action)
    }

    static func reduce(_ state: State, _ event: Event) -> State {
        switch (state.posts, state.loading, event) {
        // Initial state, posts have been loaded (from disk).
        case (.empty, .idle, .loadedPosts(let posts)):
            return State(posts: .showing(posts, selected: nil), loading: .idle)

        // We have signaled to start downloading, no matter if we have posts or not.
        case (let posts, .idle, .startDownloadingPosts):
            return State(posts: posts, loading: .loading)

        // We have signaled to start downloading, no matter if we have posts or not.
        case (let posts, .idle, .ui(.updateTapped)):
            return State(posts: posts, loading: .loading)

        // Switch to idle and display posts or empty state when post loading is finished.
        case (_, .loading, .loadedPosts(let posts)):
            let postState: PostsState
            if posts.isEmpty {
                postState = .empty
            } else {
                postState = .showing(posts, selected: nil)
            }
            return State(posts: postState, loading: .idle)

        // Switch to error state if we got a download error.
        case (let posts, .loading, .failedLoadingPosts(let error)):
            return State(posts: posts, loading: .error(error))

        // If we are in error state, switch back to idle.
        case (let posts, .error(_), _):
            return State(posts: posts, loading: .idle)

        // A post has been selected.
        case (.showing(let posts, selected: _), let loading, .ui(.selectedPost(let post))):
            return State(posts: .showing(posts, selected: post), loading: loading)

        // Deselect a post after it has been selected.
        case (.showing(let posts, selected: let post), let loading, .selectedPost) where post != nil:
            return State(posts: .showing(posts, selected: nil), loading: loading)

        default:
            return state
        }
    }

    private static func makeRoute(_ state: State) -> Route? {
        switch (state.posts, state.loading) {
        case (.showing(_, selected: let post), _) where post != nil:
            return .showPost(post!)

        case (_, .error(let error)):
            return .showError(error)

        default:
            return nil
        }
    }
}

// MARK: Feedbacks

extension PostListViewModel {
    static func userActions(actions: Signal<Action, NoError>) -> Feedback<State, Event> {
        return Feedback { _ in
            return actions.map(Event.ui)
        }
    }

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

            return downloader.downloadPosts(overwriteExisting: true)
                .map(Event.loadedPosts)
                .replaceError { Event.failedLoadingPosts($0.toUserFacingError()) }
        }
    }

    /// Deselect a post after it has been selected.
    static func whenPostSelected() -> Feedback<State, Event> {
        return Feedback { state -> SignalProducer<Event, NoError> in
            switch state.posts {
            case .showing(_, selected: let selected) where selected != nil:
                return .init(value: .selectedPost)
            default:
                return .empty
            }
        }
    }
}

// MARK: State machine

extension PostListViewModel {
    enum PostsState: Equatable {
        case empty
        case showing([RichPost], selected: RichPost?)
    }

    enum LoadingState: Equatable {
        case idle
        case loading
        case error(UserFacingError)
    }

    struct State: Equatable {
        let posts: PostsState
        let loading: LoadingState
    }

    enum Event: Equatable {
        case ui(Action)
        case loadedPosts([RichPost])
        case failedLoadingPosts(UserFacingError)
        case startDownloadingPosts
        case selectedPost
    }

    enum Action: Equatable {
        case selectedPost(RichPost)
        case updateTapped
    }

    enum Route {
        case showPost(RichPost)
        case showError(UserFacingError)
    }
}

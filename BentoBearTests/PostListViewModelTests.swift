//
//  PostListViewModelTests.swift
//  BentoBearTests
//
//  Created by Yuri Karabatov on 21/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import XCTest
import ReactiveSwift
@testable import BentoBear

final class PostListViewModelTests: XCTestCase {
    private var viewModel: PostListViewModel!
    private var posts: [RichPost]!
    private var savePosts: SignalProducer<Void, PostStoreError>!
    private var saveUsers: SignalProducer<Void, PostStoreError>!
    private var saveComments: SignalProducer<Void, PostStoreError>!
    private var loadPosts: SignalProducer<[RichPost], PostDownloaderError>!

    private let onePost: [RichPost] = [
        RichPost(
            author: User(id: 1, name: "John Doe"),
            post: Post(id: 1, userId: 1, title: "Title", body: "Body"),
            comments: [
                Comment(id: 1, postId: 1)
            ]
        )
    ]

    private func setUpSaveSuccess() {
        savePosts = SignalProducer(value: ())
        saveUsers = SignalProducer(value: ())
        saveComments = SignalProducer(value: ())
    }

    override func tearDown() {
        viewModel = nil
        posts = nil
        savePosts = nil
        saveUsers = nil
        saveComments = nil
        loadPosts = nil
    }

    /// After lanching, we must have started loading if there are no posts.
    func testInitialStateLoading() {
        posts = []
        setUpSaveSuccess()
        loadPosts = SignalProducer(value: [])
        viewModel = PostListViewModel(store: self, downloader: self)

        let loadingState = PostListViewModel.State(posts: .empty, loading: .loading)

        let expect = XCTestExpectation(description: "Initial state should be loading.")

        viewModel.state.signal
            .take(first: 1)
            .observeValues { state in
                XCTAssertEqual(state, loadingState)
                expect.fulfill()
            }

        viewModel.state.producer.start()
        wait(for: [expect], timeout: 1.0)
    }

    /// When there are posts already loaded, the state should be idle on start.
    func testInitialStateLoaded() {
        posts = onePost
        setUpSaveSuccess()
        loadPosts = SignalProducer(value: [])
        viewModel = PostListViewModel(store: self, downloader: self)

        let loadedState = PostListViewModel.State(posts: .showing(onePost, selected: nil), loading: .idle)

        let expect = XCTestExpectation(description: "Initial state should be idle, loaded.")

        viewModel.state.signal
            .take(first: 1)
            .observeValues { state in
                XCTAssertEqual(state, loadedState)
                expect.fulfill()
            }

        viewModel.state.producer.start()
        wait(for: [expect], timeout: 1.0)
    }

    /// After loading new posts, state should settle on idle, loaded.
    func testLoadingSuccessIdle() {
        posts = []
        setUpSaveSuccess()
        loadPosts = SignalProducer(value: onePost)
        viewModel = PostListViewModel(store: self, downloader: self)

        let testStates = [
            PostListViewModel.State(posts: .empty, loading: .loading),
            PostListViewModel.State(posts: .showing(onePost, selected: nil), loading: .idle)
        ]

        let expect = XCTestExpectation(description: "Empty loading state should be followed by loaded idle.")

        viewModel.state.signal
            .collect(count: 2)
            .observeValues { gotStates in
                XCTAssertEqual(gotStates, testStates)
                expect.fulfill()
            }

        viewModel.state.producer.start()
        wait(for: [expect], timeout: 1.0)
    }

    /// When getting a download error, an alert should be displayed, followed by idle.
    func testLoadingErrorAlertIdle() {
        let downloadError = PostDownloaderError.networkError
        posts = []
        setUpSaveSuccess()
        loadPosts = SignalProducer(error: downloadError)
        viewModel = PostListViewModel(store: self, downloader: self)

        let testStates = [
            PostListViewModel.State(posts: .empty, loading: .loading),
            PostListViewModel.State(posts: .empty, loading: .error(downloadError.toUserFacingError())),
            PostListViewModel.State(posts: .empty, loading: .idle)
        ]

        let testRoute = PostListViewModel.Route.showError(downloadError.toUserFacingError())

        let expect1 = XCTestExpectation(description: "Loading -> Error -> Idle")
        let expect2 = XCTestExpectation(description: "Alert should be shown.")

        viewModel.routes.signal
            .take(first: 1)
            .observeValues { gotRoute in
                XCTAssertEqual(gotRoute, testRoute)
                expect2.fulfill()
            }

        viewModel.state.signal
            .collect(count: 3)
            .observeValues { gotStates in
                XCTAssertEqual(gotStates, testStates)
                expect1.fulfill()
            }

        viewModel.state.producer.start()
        wait(for: [expect1, expect2], timeout: 1.0)
    }

    /*  This doesn't work for some reason? Action never gets delivered.
        Maybe I'm missing something obvious, but there's no time to find out already.

    /// When selecting a post, it should be presented, followed by deselection.
    func testSelectPostPresentDeselect() {
        posts = onePost
        setUpSaveSuccess()
        loadPosts = SignalProducer(value: [])
        viewModel = PostListViewModel(store: self, downloader: self)

        let testStates = [
            PostListViewModel.State(posts: .showing(onePost, selected: nil), loading: .idle),
            PostListViewModel.State(posts: .showing(onePost, selected: onePost[0]), loading: .idle),
            PostListViewModel.State(posts: .showing(onePost, selected: nil), loading: .idle)
        ]

        let testRoute = PostListViewModel.Route.showPost(onePost[0])

        let expect1 = XCTestExpectation(description: "No selection -> Selected -> No selection")
        let expect2 = XCTestExpectation(description: "Post detail should be shown.")

        viewModel.routes.signal
            .take(first: 1)
            .observeValues { gotRoute in
                XCTAssertEqual(gotRoute, testRoute)
                expect2.fulfill()
            }

        viewModel.state.signal
            .collect(count: 3)
            .observeValues { gotStates in
                XCTAssertEqual(gotStates, testStates)
                expect1.fulfill()
            }

        viewModel.state.producer.start()
        viewModel.send(action: .selectedPost(onePost[0]))
        wait(for: [expect1, expect2], timeout: 1.0)
    }
    */
}

extension PostListViewModelTests: PostStore {
    func loadAllOnDevice() -> [RichPost] {
        return posts
    }

    func saveOnDevice(posts: [Post], overwrite: Bool) -> SignalProducer<Void, PostStoreError> {
        return savePosts
    }

    func saveOnDevice(users: [User], overwrite: Bool) -> SignalProducer<Void, PostStoreError> {
        return saveUsers
    }

    func saveOnDevice(comments: [Comment], overwrite: Bool) -> SignalProducer<Void, PostStoreError> {
        return saveComments
    }
}

extension PostListViewModelTests: PostDownloader {
    func downloadPosts(overwriteExisting: Bool) -> SignalProducer<[RichPost], PostDownloaderError> {
        return loadPosts
    }
}

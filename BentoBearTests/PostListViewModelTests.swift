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
    }

    /// After lanching, we must have started loading if there are no posts.
    func testInitialStateLoading() {
        posts = []
        setUpSaveSuccess()
        viewModel = PostListViewModel(store: self, downloader: self)

        let loadingState = PostListViewModel.State(posts: .empty, loading: .loading)

        let expect = XCTestExpectation(description: "Initial state should be loading.")

        viewModel.state.signal
            .take(first: 1)
            .logEvents()
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
        viewModel = PostListViewModel(store: self, downloader: self)

        let loadedState = PostListViewModel.State(posts: .showing(onePost, selected: nil), loading: .idle)

        let expect = XCTestExpectation(description: "Initial state should be idle, loaded.")

        viewModel.state.signal
            .take(first: 1)
            .logEvents()
            .observeValues { state in
                XCTAssertEqual(state, loadedState)
                expect.fulfill()
            }

        viewModel.state.producer.start()
        wait(for: [expect], timeout: 1.0)
    }
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
        return SignalProducer.init(value: [])
    }
}

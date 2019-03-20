//
//  PostDownloader.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

enum PostDownloaderError: Error {
    case networkError
}

extension PostDownloaderError: UserFacingErrorConvertible {
    func toUserFacingError() -> UserFacingError {
        switch self {
        case .networkError:
            return UserFacingError(
                title: "PostDownloaderErrors.NetworkError.Title".localized(),
                message: "PostDownloaderErrors.NetworkError.Message".localized()
            )
        }
    }
}

protocol PostDownloader {
    /// Downloads posts, saves them and returns all posts from the store.
    func downloadPosts(overwriteExisting: Bool) -> SignalProducer<[RichPost], PostDownloaderError>
}

final class PostDownloaderSaving: PostDownloader {
    private let store: PostStore
    private let netData: NetworkData

    init(saveTo store: PostStore, downloadWith: NetworkData) {
        self.store = store
        self.netData = downloadWith
    }

    func downloadPosts(overwriteExisting: Bool) -> SignalProducer<[RichPost], PostDownloaderError> {
        let newUsers = netData.fetchData(from: "http://jsonplaceholder.typicode.com/users")
            .mapError { _ in PostDownloaderError.networkError }
            .attemptMap { PostDownloaderSaving.tryMapping(data: $0, toType: [User].self) }

        let newComments = netData.fetchData(from: "http://jsonplaceholder.typicode.com/comments")
            .mapError { _ in PostDownloaderError.networkError }
            .attemptMap { PostDownloaderSaving.tryMapping(data: $0, toType: [Comment].self) }

        let newPosts = netData.fetchData(from: "http://jsonplaceholder.typicode.com/posts")
            .mapError { _ in PostDownloaderError.networkError }
            .attemptMap { PostDownloaderSaving.tryMapping(data: $0, toType: [Post].self) }

        return SignalProducer.combineLatest(newUsers, newComments, newPosts)
            .flatMap(.latest) { [weak self] users, comments, posts -> SignalProducer<[Void], PostDownloaderError> in
                guard let strongSelf = self else { return .empty }

                return strongSelf.store.saveOnDevice(users: users, overwrite: true)
                    .merge(with: strongSelf.store.saveOnDevice(comments: comments, overwrite: true))
                    .merge(with: strongSelf.store.saveOnDevice(posts: posts, overwrite: true))
                    .mapError { _ in PostDownloaderError.networkError }
                    .collect()
            }
            .attemptMap { [weak self] voids -> Result<[RichPost], PostDownloaderError> in
                guard voids.count == 3 else {
                    return Result(error: .networkError)
                }

                return Result(value: self?.store.loadAllOnDevice() ?? [])
            }
    }

    static func tryMapping<T: Decodable>(data: Data, toType: T.Type) -> Result<T, PostDownloaderError> {
        do {
            let decoded = try JSONDecoder().decode(toType, from: data)
            return Result(value: decoded)
        } catch {
            return Result(error: .networkError)
        }
    }
}

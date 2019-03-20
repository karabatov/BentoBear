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
    func downloadPosts(overwriteExisting: Bool) -> SignalProducer<[Post], PostDownloaderError>
}

final class PostDownloaderSaving: PostDownloader {
    private let store: PostStore
    private let netData: NetworkData

    init(saveTo store: PostStore, downloadWith: NetworkData) {
        self.store = store
        self.netData = downloadWith
    }

    func downloadPosts(overwriteExisting: Bool) -> SignalProducer<[Post], PostDownloaderError> {
        return netData.fetchData(from: "http://jsonplaceholder.typicode.com/posts")
            .attemptMap({ (data: Data) -> Result<[Post], NetworkDataError> in
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    self.store.saveOnDevice(posts: posts, overwrite: true)
                    return Result(value: self.store.loadAllOnDevice())
                } catch {
                    return Result(error: NetworkDataError.networkError)
                }
            })
            .mapError { _ in PostDownloaderError.networkError }
    }
}

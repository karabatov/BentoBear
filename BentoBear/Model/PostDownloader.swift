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

    init(saveTo store: PostStore) {
        self.store = store
    }

    func downloadPosts(overwriteExisting: Bool) -> SignalProducer<[Post], PostDownloaderError> {
        return SignalProducer.init { observer, _ in
            guard let url = URL(string: "http://jsonplaceholder.typicode.com/posts") else { return }

            let completion: (Data?, URLResponse?, Error?) -> Void = { (maybeData, maybeResponse, error) in
                guard let data = maybeData, error == nil else {
                    observer.send(error: .networkError)
                    observer.sendCompleted()
                    return
                }

                let posts = try! JSONDecoder().decode([Post].self, from: data)
                observer.send(value: posts)
                observer.sendCompleted()
            }

            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
    }

    func downloadPosts(overwriteExisting: Bool) -> [Post] {
        _ = store.saveOnDevice(posts: [], overwrite: true)
        return store.loadAllOnDevice()
    }
}

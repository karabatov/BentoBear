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

            let completion: (Data?, URLResponse?, Error?) -> Void = { [weak self] (maybeData, maybeResponse, error) in
                defer {
                    observer.sendCompleted()
                }

                guard let data = maybeData, error == nil else {
                    observer.send(error: .networkError)
                    return
                }

                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    _ = self?.store.saveOnDevice(posts: posts, overwrite: true)
                    observer.send(value: self?.store.loadAllOnDevice() ?? [])
                } catch {
                    observer.send(error: .networkError)
                }
            }

            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
    }
}

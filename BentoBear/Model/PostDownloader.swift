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

protocol PostDownloader {
    /// Downloads posts, saves them and returns all posts from the store.
    func downloadPosts(overwriteExisting: Bool) -> SignalProducer<[Post], PostDownloaderError>
}

final class PostDownloaderSaving: PostDownloader {
    private let store: PostStore
    private let session = URLSession()

    init(saveTo store: PostStore) {
        self.store = store
    }

    func downloadPosts(overwriteExisting: Bool) -> SignalProducer<[Post], PostDownloaderError> {
        return SignalProducer.init { [weak self] observer, _ in
            guard
                let session = self?.session,
                let url = URL(string: "http://jsonplaceholder.typicode.com/posts")
            else { return }

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

            session.dataTask(with: url, completionHandler: completion).resume()
        }
    }

    func downloadPosts(overwriteExisting: Bool) -> [Post] {
        _ = store.saveOnDevice(posts: [], overwrite: true)
        return store.loadAllOnDevice()
    }
}

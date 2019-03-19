//
//  PostStore.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol PostStore {
    func loadAllOnDevice() -> [Post]
    func loadOnDevice(filter: ((Post) -> Bool)?) -> [Post]
    /// Saves the posts on device.
    /// - Parameter overwrite: If `true`, overwrite posts with the same `PostID`.
    ///     When `false`, if the post already exists in the DB, it will not be overwritten.
    func saveOnDevice(posts: [Post], overwrite: Bool)
}

final class PostStoreDefaults: PostStore {
    private static let dataKey = "PostStoreDefaults.Posts"
    private let defaults = UserDefaults.standard
    private let queue = DispatchQueue(label: "PostStoreDefaults")
    private var postCache: Dictionary<PostID, Post>

    init() {
        if
            let data = defaults.data(forKey: PostStoreDefaults.dataKey),
            let oldCache = try? JSONDecoder().decode([PostID : Post].self, from: data)
        {
            postCache = oldCache
        } else {
            postCache = [:]
        }

    }

    func loadAllOnDevice() -> [Post] {
        return postCache.values
            .map { $0 }
            .sorted(by: { l, r -> Bool in
                l.id < r.id
            })
    }

    func loadOnDevice(filter: ((Post) -> Bool)?) -> [Post] {
        return loadAllOnDevice().filter(filter ?? { _ in true })
    }

    func saveOnDevice(posts: [Post], overwrite: Bool) {
        queue.sync {
            var newCache = postCache
            for post in posts {
                guard newCache[post.id] == nil || overwrite else {
                    return
                }

                newCache[post.id] = post
            }
            postCache = newCache

            DispatchQueue.global().async { [weak self] in
                self?.saveToDefaults(cache: newCache)
            }
        }
    }

    private func saveToDefaults(cache: [PostID : Post]) {
        guard let data = try? JSONEncoder().encode(cache) else {
            return
        }

        defaults.set(data, forKey: PostStoreDefaults.dataKey)
        defaults.synchronize()
    }
}

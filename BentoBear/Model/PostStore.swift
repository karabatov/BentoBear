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
    func loadAllOnDevice() -> [RichPost]
    /// Saves the posts on device.
    /// - Parameter overwrite: If `true`, overwrite posts with the same `PostID`.
    ///     When `false`, if the post already exists in the DB, it will not be overwritten.
    func saveOnDevice(posts: [Post], overwrite: Bool)
    /// Saves the users on device.
    /// - Parameter overwrite: If `true`, overwrite users with the same `UserID`.
    ///     When `false`, if the user already exists in the DB, it will not be overwritten.
    func saveOnDevice(users: [User], overwrite: Bool)
    /// Saves the comments on device.
    /// - Parameter overwrite: If `true`, overwrite comments with the same `CommentID`.
    ///     When `false`, if the comment already exists in the DB, it will not be overwritten.
    func saveOnDevice(comments: [Comment], overwrite: Bool)
}

final class PostStoreDefaults: PostStore {
    private static let postKey = "PostStoreDefaults.Posts"
    private static let userKey = "PostStoreDefaults.Posts"
    private static let commentKey = "PostStoreDefaults.Posts"

    private let defaults = UserDefaults.standard
    private let queue = DispatchQueue(label: "PostStoreDefaults")
    private var postCache: Dictionary<PostID, Post>
    private var userCache: Dictionary<UserID, User>
    private var commentCache: Dictionary<PostID, [Comment]>

    init() {
        if
            let userData = defaults.data(forKey: PostStoreDefaults.userKey),
            let commentData = defaults.data(forKey: PostStoreDefaults.commentKey),
            let postData = defaults.data(forKey: PostStoreDefaults.postKey),
            let oldUserCache = try? JSONDecoder().decode([UserID : User].self, from: userData),
            let oldCommentCache = try? JSONDecoder().decode([PostID : [Comment]].self, from: commentData),
            let oldPostCache = try? JSONDecoder().decode([PostID : Post].self, from: postData)
        {
            userCache = oldUserCache
            commentCache = oldCommentCache
            postCache = oldPostCache
        } else {
            userCache = [:]
            commentCache = [:]
            postCache = [:]
        }

    }

    func loadAllOnDevice() -> [RichPost] {
        return postCache.values
            .map { post in
                RichPost(
                    author: userCache[post.userId] ?? User.unnamed,
                    post: post,
                    comments: commentCache[post.id] ?? []
                )
            }
            .sorted(by: { l, r -> Bool in
                l.post.id < r.post.id
            })
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
                self?.saveToDefaults(cache: newCache, key: PostStoreDefaults.postKey)
            }
        }
    }

    func saveOnDevice(users: [User], overwrite: Bool) {
        queue.sync {
            var newCache = userCache
            for user in users {
                guard newCache[user.id] == nil || overwrite else {
                    return
                }

                newCache[user.id] = user
            }
            userCache = newCache

            DispatchQueue.global().async { [weak self] in
                self?.saveToDefaults(cache: newCache, key: PostStoreDefaults.userKey)
            }
        }
    }

    func saveOnDevice(comments: [Comment], overwrite: Bool) {
        queue.sync {
            var newCache = commentCache
            for comment in comments {
                var newComments = newCache[comment.postId] ?? []
                if let idx = newComments.firstIndex(where: { $0.id == comment.id }), overwrite {
                    newComments[idx] = comment
                } else {
                    newComments.append(comment)
                }
                newCache[comment.postId] = newComments
            }
            commentCache = newCache

            DispatchQueue.global().async { [weak self] in
                self?.saveToDefaults(cache: newCache, key: PostStoreDefaults.commentKey)
            }
        }
    }

    private func saveToDefaults<T: Encodable>(cache: T, key: String) {
        guard let data = try? JSONEncoder().encode(cache) else {
            return
        }

        defaults.set(data, forKey: key)
        defaults.synchronize()
    }
}

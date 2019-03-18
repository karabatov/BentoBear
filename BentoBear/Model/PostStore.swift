//
//  PostStore.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation

protocol PostStore {
    func loadAllOnDevice() -> [Post]
    func loadOnDevice(filter: ((Post) -> Bool)?) -> [Post]
    /// Saves the posts on device.
    /// - Parameter overwrite: If `true`, overwrite posts with the same `PostID`.
    ///     When `false`, if the post already exists in the DB, it will not be overwritten.
    /// - Returns: The list of posts which were actually saved (exludes non-overwritten).
    func saveOnDevice(posts: [Post], overwrite: Bool) -> [Post]
}

final class PostStoreDefaults: PostStore {
    init() {

    }

    func loadAllOnDevice() -> [Post] {
        return []
    }

    func loadOnDevice(filter: ((Post) -> Bool)?) -> [Post] {
        return []
    }

    func saveOnDevice(posts: [Post], overwrite: Bool) -> [Post] {
        return []
    }
}

//
//  PostDownloader.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation

protocol PostDownloader {
    func downloadPosts(overwriteExisting: Bool) -> [Post]
}

final class PostDownloaderSaving: PostDownloader {
    private let store: PostStore

    init(saveTo store: PostStore) {
        self.store = store
    }

    /// Downloads posts, saves them and returns all posts from the store.
    func downloadPosts(overwriteExisting: Bool) -> [Post] {
        _ = store.saveOnDevice(posts: [], overwrite: true)
        return store.loadAllOnDevice()
    }
}

//
//  PostListViewModel.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 18/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import BentoKit

final class PostListViewModel {

}

extension PostListViewModel {
    enum PostsState: Equatable {
        case empty
        case showing([Post])
    }

    enum LoadingState: Equatable {
        case idle
        case loading
        case error(String)
    }

    struct State: Equatable {
        let posts: PostsState
        let loading: LoadingState
    }
}

//
//  PostDetailRenderer.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 20/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import Bento
import BentoKit

struct PostDetailRenderer: BoxRenderer {
    private let config: Config
    private let observer: Sink<PostDetailViewModel.Action>

    init(observer: @escaping Sink<PostDetailViewModel.Action>, appearance: Appearance, config: Config) {
        self.config = config
        self.observer = observer
    }

    func render(state: PostDetailViewModel.State) -> Screen<SectionID, RowID> {
        switch state {
        case .showingPost(let post):
            return Screen(
                title: "Post",
                box: Box.empty
                    |-+ Section(id: SectionID.post)
                    |---+ Node(
                        id: RowID.author,
                        component: Component.Description(
                            text: post.author.name,
                            styleSheet: Component.Description.StyleSheet()
                        )
                    )
                    |---+ Node(
                        id: RowID.title,
                        component: Component.Description(
                            text: post.post.title,
                            styleSheet: Component.Description.StyleSheet()
                        )
                    )
                    |---+ Node(
                        id: RowID.body,
                        component: Component.Description(
                            text: post.post.body,
                            styleSheet: Component.Description.StyleSheet()
                        )
                    )
                    |---+ Node(
                        id: RowID.comments,
                        component: Component.Description(
                            text: String(post.comments.count),
                            styleSheet: Component.Description.StyleSheet()
                        )
                    )
                )
        }
    }
}

extension PostDetailRenderer {
    struct Config {}

    struct Appearance: BoxAppearance {
        var traits = UITraitCollection()
    }

    enum SectionID: Hashable {
        case post
    }

    enum RowID: Hashable {
        case author
        case title
        case body
        case comments
    }
}

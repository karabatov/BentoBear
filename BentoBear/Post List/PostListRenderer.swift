//
//  PostListRenderer.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import UIKit
import Bento
import BentoKit
import StyleSheets
import ReactiveSwift

struct PostListRenderer: BoxRenderer {
    private let config: Config
    private let observer: Sink<PostListViewModel.Action>

    private let updateButton = BarButtonItem.init(appearance: .text("PostList.UpdateButton".localized()))
    private let activity = BarButtonItem.init(appearance: .activityIndicator)

    private var noPostsStyleSheet: Component.Description.StyleSheet {
        return Component.Description.StyleSheet()
    }

    init(observer: @escaping Sink<PostListViewModel.Action>, appearance: Appearance, config: Config) {
        self.config = config
        self.observer = observer
    }

    func render(state: PostListViewModel.State) -> Screen<SectionID, RowID> {
        return renderEmpty(rightBarItems: [activity])
    }

    private func renderEmpty(rightBarItems: [BarButtonItem]) -> Screen<SectionID, RowID> {
        return Screen(
            title: ("PostList.Title").localized(),
            rightBarItems: rightBarItems,
            formStyle: .centerYAligned,
            box: Box.empty
                |-+ Section(id: SectionID.posts)
                |---+ Node(
                    id: RowID.noPostsMessage,
                    component: Component.Description(
                        text: ("PostList.NoPostsMessage").localized(),
                        styleSheet: noPostsStyleSheet)
                    )
                )
    }
}

extension PostListRenderer {
    struct Config {}

    struct Appearance: BoxAppearance {
        var traits = UITraitCollection()
    }

    enum SectionID: Hashable {
        case posts
    }

    enum RowID: Hashable {
        case noPostsMessage
        case post
    }
}

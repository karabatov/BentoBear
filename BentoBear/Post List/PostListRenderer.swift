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

    private let updateButton: BarButtonItem
    private let activity = BarButtonItem.init(appearance: .activityIndicator)

    private var noPostsStyleSheet: Component.Description.StyleSheet {
        return Component.Description.StyleSheet(
            text: LabelStyleSheet(
                font: UIFont.preferredFont(forTextStyle: .footnote),
                textColor: UIColor.lightGray,
                textAlignment: .center,
                numberOfLines: 0,
                lineBreakMode: .byWordWrapping
            )
        )
    }

    init(observer: @escaping Sink<PostListViewModel.Action>, appearance: Appearance, config: Config) {
        self.config = config
        self.observer = observer

        updateButton = BarButtonItem(
            appearance: .text("PostList.UpdateButton".localized()),
            accessibilityIdentifier: "PostList.UpdateButton".localized(),
            callback: .updateTapped >>> observer
        )
    }

    func render(state: PostListViewModel.State) -> Screen<SectionID, RowID> {
        let rightBarItems: [BarButtonItem]
        switch state.loading {
        case .idle, .error(_):
            rightBarItems = [updateButton]
        case .loading:
            rightBarItems = [activity]
        }

        switch state.posts {
        case .empty:
            return renderEmpty(rightBarItems: rightBarItems)
        case .showing(let posts, selected: _):
            return renderPosts(posts, rightBarItems: rightBarItems)
        }
    }

    private func renderEmpty(rightBarItems: [BarButtonItem]) -> Screen<SectionID, RowID> {
        return Screen(
            title: ("PostList.Title").localized(),
            rightBarItems: rightBarItems,
            formStyle: .centerYAligned,
            shouldUseSystemSeparators: false,
            box: Box.empty
                |-+ Section(id: SectionID.empty)
                |---+ Node(
                    id: RowID.noPostsMessage,
                    component: Component.Description(
                        text: ("PostList.NoPostsMessage").localized(),
                        styleSheet: noPostsStyleSheet
                    )
                )
            )
    }

    private func renderPosts(_ posts: [RichPost], rightBarItems: [BarButtonItem]) -> Screen<SectionID, RowID> {
        return Screen(
            title: ("PostList.Title").localized(),
            rightBarItems: rightBarItems,
            box: Box.empty
                |-+ Section(id: SectionID.posts)
                |---* posts.map { post in
                    Node(
                        id: RowID.post,
                        component: Component.TitledDescription(
                            texts: [
                                // So that it looks more like an actual title.
                                .plain(post.post.title.localizedCapitalized),
                                .plain(post.bodyExcerpt())
                            ],
                            detail: nil,
                            accessory: .chevron,
                            didTap: .selectedPost(post) >>> observer,
                            styleSheet: Component.TitledDescription.StyleSheet()
                                .compose(\.textStyles[0].textColor, UIColor.darkText)
                        )
                    )
                }
        )
    }
}

extension PostListRenderer {
    struct Config {}

    struct Appearance: BoxAppearance {
        var traits = UITraitCollection()
    }

    enum SectionID: Hashable {
        case empty
        case posts
    }

    enum RowID: Hashable {
        case noPostsMessage
        case post
    }
}

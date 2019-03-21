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
import StyleSheets

struct PostDetailRenderer: BoxRenderer {
    private let config: Config
    private let observer: Sink<PostDetailViewModel.Action>

    private var titleStyle: Component.Description.StyleSheet {
        return Component.Description.StyleSheet(
            text: LabelStyleSheet(
                font: UIFont.preferredFont(forTextStyle: .headline)
            )
        )
    }

    private var authorStyle: Component.Description.StyleSheet {
        return Component.Description.StyleSheet(
            text: LabelStyleSheet(
                font: UIFont.preferredFont(forTextStyle: .subheadline),
                textColor: UIColor.lightGray
            )
        )
    }

    private var commentStyle: Component.Description.StyleSheet {
        return Component.Description.StyleSheet(
            text: LabelStyleSheet(
                font: UIFont.preferredFont(forTextStyle: .footnote),
                textColor: UIColor.darkGray,
                textAlignment: .center
            )
        )
    }

    init(observer: @escaping Sink<PostDetailViewModel.Action>, appearance: Appearance, config: Config) {
        self.config = config
        self.observer = observer
    }

    func render(state: PostDetailViewModel.State) -> Screen<SectionID, RowID> {
        switch state {
        case .showingPost(let post):
            return Screen(
                title: "PostDetail.Title".localized(),
                shouldUseSystemSeparators: false,
                box: Box.empty
                    |-+ Section(id: SectionID.post)
                    |---+ Node(
                        id: RowID.title,
                        component: Component.Description(
                            text: post.post.title.localizedCapitalized,
                            styleSheet: titleStyle
                        )
                    )
                    |---+ Node(
                        id: RowID.author,
                        component: Component.Description(
                            text: String(format: "PostDetail.ByAuthor".localized(), post.author.name),
                            styleSheet: authorStyle
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
                            // Localized plural support for the number of comments :3
                            text: String.localizedStringWithFormat("PostDetail.NComments".localized(), post.comments.count),
                            styleSheet: commentStyle
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

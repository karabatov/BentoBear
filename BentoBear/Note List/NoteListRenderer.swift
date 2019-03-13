//
//  NoteListRenderer.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 13/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import UIKit
import Bento
import BentoKit
import StyleSheets
import ReactiveSwift

struct NoteListRendererContext {}

struct NoteListRenderer: BoxRenderer {
    private let config: Config
    private let observer: Sink<NoteListViewModel.Action>

    struct Config {
        let context: NoteListRendererContext
    }

    struct Appearance: BoxAppearance {
        var traits: UITraitCollection = UITraitCollection.init()
    }

    init(observer: @escaping Sink<NoteListViewModel.Action>, appearance: Appearance, config: Config) {
        self.config = config
        self.observer = observer
    }

    func render(state: NoteListViewModel.State) -> Screen<NoteListRenderer.SectionId, NoteListRenderer.RowId> {
        switch state {
        case .empty:
            return renderEmpty()
        }
    }

    private func renderEmpty() -> Screen<SectionId, RowId> {
        return Screen(
            title: "Notes",
            box: Box.empty
                |-+ Section(id: SectionId.info)
                |---+ Node(id: RowId.info, component:
                    Component.Description(
                        text: "No notes",
                        styleSheet: Component.Description.StyleSheet()
                    )
                )
        )
    }
}

extension NoteListRenderer {

    enum SectionId: Hashable {
        case info
    }

    enum RowId: Hashable {
        case info
    }
}

//
//  PostDetailViewModel.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 20/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import BentoKit
import ReactiveSwift
import Result

final class PostDetailViewModel: BoxViewModel {
    let state: Property<State>

    private let (actions, actionsObserver) = Signal<Action, NoError>.pipe()

    init(post: RichPost) {
        state = Property(
            initial: .showingPost(post),
            reduce: PostDetailViewModel.reduce,
            feedbacks: []
        )
    }

    func send(action: Action) {
        actionsObserver.send(value: action)
    }

    private static func reduce(_ state: State, _ event: Event) -> State {
        return state
    }
}

extension PostDetailViewModel {
    enum State: Equatable {
        case showingPost(RichPost)
    }

    enum Event: Equatable {

    }

    enum Action: Equatable {

    }
}

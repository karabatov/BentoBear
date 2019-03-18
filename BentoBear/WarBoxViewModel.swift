//
//  WarBoxViewModel.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 18/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import BentoKit
import ReactiveSwift
import ReactiveFeedback
import Result

protocol StateType: Equatable {
    static func initial() -> Self
}

class WarBoxViewModel<A: Equatable, R, E: Equatable, S: StateType>: BoxViewModel {
    typealias State = S
    typealias Action = A

    let state: Property<S>
    let routes: Signal<R, NoError>

    init() {
        state = Property(
            initial: S.initial(),
            reduce: WarBoxViewModel.reduce,
            feedbacks: WarBoxViewModel.feedbacks()
        )

        routes = state.signal.skipRepeats().filterMap(WarBoxViewModel.makeRoute)
    }

    private let (actions, actionsObserver) = Signal<A, NoError>.pipe()

    func send(action: A) {
        actionsObserver.send(value: action)
    }

    static func reduce(_ state: S, _ event: E) -> S {
        fatalError("Not implemented.")
    }

    static func makeRoute(_ state: S) -> R? {
        fatalError("Not implemented.")
    }

    static func feedbacks() -> [Feedback<S, E>] {
        fatalError("Not implemented.")
    }
}

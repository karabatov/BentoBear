//
//  NoteListViewModel.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 13/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import Bento
import BentoKit
import ReactiveCocoa
import ReactiveSwift
import ReactiveFeedback
import Result

final class NoteListViewModel: BoxViewModel {
    let state: Property<State>
    let routes: Signal<Route, NoError>

    private let (actions, actionsObserver) = Signal<Action, NoError>.pipe()

    init() {
        state = Property(
            initial: .empty,
            reduce: NoteListViewModel.reduce,
            feedbacks: []
        )

        routes = state.signal.skipRepeats().filterMap { state in
            switch state {
            case .empty:
                return nil
            }
        }
    }

    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .empty:
            return reduceEmpty(state: state, event: event)
        }
    }

    func send(action: NoteListViewModel.Action) {
        actionsObserver.send(value: action)
    }
}

// MARK: State machine

extension NoteListViewModel {
    enum State: Equatable {
        case empty
    }

    enum Event: Equatable {
        case ui(Action)
    }

    enum Action: Equatable {
        case addNote
        case select(index: Int)
    }

    enum Route {
        case showNote
    }
}

// MARK: Reducers

extension NoteListViewModel {
    static func reduceEmpty(state: State, event: Event) -> State {
        switch event {
        default:
            return state
        }
    }
}

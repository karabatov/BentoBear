//
//  AresViewModel.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 18/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

/*

import Foundation
import BentoKit
import ReactiveSwift
import ReactiveFeedback
import Result

protocol StateType: Equatable {
    static func initial() -> Self
}

protocol AresViewModel: BoxViewModel where State == S, Action == A {
    associatedtype A: Equatable
    associatedtype R
    associatedtype E: Equatable
    associatedtype S: StateType

    var routes: Signal<R, NoError> { get }
    var actions: Signal<A, NoError> { get }
    var actionsObserver: Signal<A, NoError>.Observer { get }

    func send(action: A)

    static func initState() -> Property<S>
    static func initRoutes(state: Property<S>) -> Signal<R, NoError>
    static func initActionsObserver() -> (Signal<A, NoError>, Signal<A, NoError>.Observer)
    static func reduce(_ state: S, _ event: E) -> S
    static func makeRoute(_ state: S) -> R?
    static func feedbacks() -> [Feedback<S, E>]
}

extension AresViewModel {
    func send(action: A) {
        actionsObserver.send(value: action)
    }

    static func initState() -> Property<S> {
        return Property(
            initial: S.initial(),
            reduce: Self.reduce,
            feedbacks: Self.feedbacks()
        )
    }

    static func initRoutes(state: Property<S>) -> Signal<R, NoError> {
        return state.signal.skipRepeats().filterMap(Self.makeRoute)
    }

    static func initActionsObserver() -> (Signal<A, NoError>, Signal<A, NoError>.Observer) {
        return Signal<A, NoError>.pipe()
    }

    static func reduce(_ state: S, _ event: E) -> S {
        fatalError()
    }

    static func makeRoute(_ state: S) -> R? {
        fatalError()
    }

    static func feedbacks() -> [Feedback<S, E>] {
        fatalError()
    }
}

class WarBoxViewModel<AA: Equatable, RR, EE: Equatable, SS: StateType>: AresViewModel {
    typealias A = AA
    typealias R = RR
    typealias E = EE
    typealias S = SS

    let state: Property<SS>
    let routes: Signal<RR, NoError>
    let actions: Signal<AA, NoError>
    let actionsObserver: Signal<AA, NoError>.Observer

    init() {
        state = WarBoxViewModel.initState()
        routes = WarBoxViewModel.initRoutes(state: state)
        (actions, actionsObserver) = WarBoxViewModel.initActionsObserver()
    }
}

final class ViewModel: WarBoxViewModel<ConcreteAction, ConcreteRoute, ConcreteEvent, ConcreteState> {
    override init() {
        super.init()
    }
}

*/

//
//  AresViewModel.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 18/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

/*  This was an initial attempt at a single protocol to create
    more uniform view models. Turns out, currently it's impossible
    to define generic type constraints in an extension, because
    it makes both the compiler and SourceKit hang. Below is the
    protocol code, and below that, an isolated test case with simple
    types which you can try out for yourself.

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

protocol LevelOne {
    associatedtype TypeOne

    var property: TypeOne { get }
}

protocol LevelTwo: LevelOne where TypeOne == TypeTwo {
    associatedtype TypeTwo: Equatable

    func foo(value: TypeTwo)
}

class LevelThree<TypeThree: Equatable>: LevelTwo {
    typealias TypeTwo = TypeThree

    let property: TypeThree

    init(value: TypeThree) {
        self.property = value
    }

    func foo(value: TypeThree) {
        fatalError()
    }
}

/// This make Swift hang.
final class LevelFour: LevelThree<LevelFour.TypeFour> {
}

extension LevelFour {
    enum TypeFour: Equatable {
        case empty
    }
}

*/

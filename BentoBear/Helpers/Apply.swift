//
//  Apply.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 20/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation

precedencegroup CompositionPrecedence {
    associativity: left
}

infix operator >>>: CompositionPrecedence

func >>> <T>(lhs: T, rhs: @escaping (T) -> Void) -> () -> Void {
    return { rhs(lhs) }
}

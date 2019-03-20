//
//  ReplaceError.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension SignalProducer {
    func replaceError(_ transform: @escaping (Error) -> Value) -> SignalProducer<Value, NoError> {
        return flatMapError { error -> SignalProducer<Value, NoError> in
            SignalProducer<Value, NoError>(value: transform(error))
        }
    }
}

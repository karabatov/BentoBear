//
//  UserFacingError.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation

struct UserFacingError: Error, Equatable {
    let title: String
    let message: String
}

protocol UserFacingErrorConvertible {
    func toUserFacingError() -> UserFacingError
}

//
//  LocalizedString.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 19/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation

extension String {
    /// Usually I would use R https://github.com/mac-cain13/R.swift but
    /// it's not worth importing it for such a small project.
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

//
//  Post.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 18/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation

typealias PostID = Int

struct Post: Equatable {
    let id: PostID
    let title: String
    let body: String
}

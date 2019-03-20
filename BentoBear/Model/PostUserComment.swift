//
//  PostUserComment.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 18/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation

// MARK: User

typealias UserID = Int

struct User: Equatable, Codable {
    let id: UserID
    let name: String

    static let unnamed = User(id: -1, name: "User.NameUnknown".localized())
}

// MARK: Post

typealias PostID = Int

struct Post: Equatable, Codable {
    let id: PostID
    let userId: UserID
    let title: String
    let body: String
}

// MARK: Comment

typealias CommentID = Int

struct Comment: Equatable, Codable {
    let id: CommentID
    let postId: PostID
}

// MARK: RichPost

struct RichPost: Equatable {
    let author: User
    let post: Post
    let comments: [Comment]
}

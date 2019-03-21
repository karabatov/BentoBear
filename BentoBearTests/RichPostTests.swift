//
//  RichPostTests.swift
//  BentoBearTests
//
//  Created by Yuri Karabatov on 21/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import XCTest
@testable import BentoBear

class RichPostTests: XCTestCase {
    func testBodyExcerptEmpty() {
        let post = RichPost(
            author: User.unnamed,
            post: Post(id: 1, userId: -1, title: "", body: ""),
            comments: []
        )

        XCTAssertEqual(post.bodyExcerpt(), "…")
    }

    func testBodyExcerptOnlyNewline() {
        let post = RichPost(
            author: User.unnamed,
            post: Post(id: 1, userId: -1, title: "", body: "\n"),
            comments: []
        )

        XCTAssertEqual(post.bodyExcerpt(), "…")
    }

    func testBodyExcerptOneLine() {
        let post = RichPost(
            author: User.unnamed,
            post: Post(id: 1, userId: -1, title: "", body: "test"),
            comments: []
        )

        XCTAssertEqual(post.bodyExcerpt(), "test…")
    }

    func testBodyExcerptTwoLines() {
        let post = RichPost(
            author: User.unnamed,
            post: Post(id: 1, userId: -1, title: "", body: "test\ntest"),
            comments: []
        )

        XCTAssertEqual(post.bodyExcerpt(), "test…")
    }

    func testBodyExcerptEightWords() {
        let post = RichPost(
            author: User.unnamed,
            post: Post(id: 1, userId: -1, title: "", body: "1 2 3 4 5 6 7 8"),
            comments: []
        )

        XCTAssertEqual(post.bodyExcerpt(), "1 2 3 4 5 6 7…")
    }
}

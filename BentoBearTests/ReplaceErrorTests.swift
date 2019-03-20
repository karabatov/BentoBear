//
//  ReplaceErrorTests.swift
//  BentoBearTests
//
//  Created by Yuri Karabatov on 21/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import XCTest
import ReactiveSwift
import Result
@testable import BentoBear

class ReplaceErrorTests: XCTestCase {
    func testReplaceError() {
        let expect = XCTestExpectation(description: "ReplaceError should convert error to value.")

        SignalProducer<Bool, TestError>(error: .failed)
            .replaceError { _ in return true }
            .on(value: { value in
                XCTAssertTrue(value)
                expect.fulfill()
            })
            .start()

        wait(for: [expect], timeout: 1.0)
    }
}

extension ReplaceErrorTests {
    enum TestError: Error {
        case failed
    }
}

//
//  CSSTests.swift
//  CSSTests
//
//  Created by Johan Dahlin on 2024-01-08.
//

import XCTest
@testable import CSS

final class CSSTests: XCTestCase {

    func testIsIdentCodePoint() throws {
        ["a", "z", "A", "Z", "0", "9", "-", "_"].forEach {
            XCTAssertTrue(CSS.Codepoint($0)!.isIdentCodePoint(), "Codepoint: \"\($0)\"")
        }
    }

    func testNotIsIdentCodePoint() throws {
        ["^"].forEach {
            XCTAssertFalse(CSS.Codepoint($0)!.isIdentCodePoint(), "Codepoint: \"\($0)\"")
        }
    }

}

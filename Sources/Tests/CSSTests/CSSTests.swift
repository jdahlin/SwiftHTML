//
//  CSSTests.swift
//  CSSTests
//
//  Created by Johan Dahlin on 2024-01-08.
//

@testable import CSS
import XCTest

final class CSSTests: XCTestCase {
    func testIsIdentCodePoint() throws {
        for item in ["a", "z", "A", "Z", "0", "9", "-", "_"] {
            XCTAssertTrue(CSS.Codepoint(item)!.isIdentCodePoint(), "Codepoint: \"\(item)\"")
        }
    }

    func testNotIsIdentCodePoint() throws {
        for item in ["^"] {
            XCTAssertFalse(CSS.Codepoint(item)!.isIdentCodePoint(), "Codepoint: \"\(item)\"")
        }
    }
}

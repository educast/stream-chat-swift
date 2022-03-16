//
//  Assert.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/11/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest

extension Robot {

    func findMatch(for identifier: String,
                   in query: XCUIElementQuery,
                   waitTimeout timeout: TimeInterval = 3.0) -> Bool {
        query.matching(identifier: identifier).firstMatch.waitForExistence(timeout: timeout)
    }

    @discardableResult
    func assertElement(_ element: XCUIElement,
                       isVisible: Bool,
                       timeout: Double = 1.5,
                       file: StaticString = #file,
                       line: UInt = #line) -> Self {
        element.wait(timeout: timeout)
        XCTAssertEqual(isVisible, element.exists,
                       "Element with label \(element.label) should be \(isVisible ? "visible" :"hidden")",
                       file: file,
                       line: line)
        return self
    }

    @discardableResult
    func assertKeyboard(isVisible: Bool,
                        file: StaticString = #file,
                        line: UInt = #line) -> Self {
        let keyboard = app.keyboards.firstMatch
        keyboard.wait(timeout: 1.5)
        XCTAssertEqual(isVisible, keyboard.exists,
                       "Keyboard should be \(isVisible ? "visible" :"hidden")",
                       file: file,
                       line: line)
        return self
    }

    @discardableResult
    func assertQuery(_ query: XCUIElementQuery,
                     count: Int,
                     timeout: Double = 5,
                     file: StaticString = #file,
                     line: UInt = #line) -> Self {
        let actualCount = query.waitCount(count, timeout: timeout)
        let errorMessage = "Expected: \(count) messages, received: \(actualCount)"
        XCTAssertEqual(actualCount, count, errorMessage, file: file, line: line)
        return self
    }

    @discardableResult
    func assertElement(_ element: XCUIElement,
                       isEnabled: Bool,
                       isVisible: Bool,
                       file: StaticString = #filePath, line: UInt = #line) -> Self {
        if isEnabled || isVisible {
            let visible = isVisible == element.isHittable
            let enabled = isEnabled == element.isEnabled
            XCTAssertTrue(visible && enabled, file: file, line: line)
        } else {
            XCTAssertFalse(element.exists, file: file, line: line)
        }
        return self
    }

    @discardableResult
    func assertElement(_ element: XCUIElement,
                       hasIndentifer identifier: String,
                       file: StaticString = #filePath,
                       line: UInt = #line) -> Self {
        XCTAssertEqual(element.identifier, identifier)
        return self
    }

    @discardableResult
    func assertElement(_ element: XCUIElement,
                       hasSize size: CGSize,
                       file: StaticString = #filePath,
                       line: UInt = #line) -> Self {
        XCTAssertEqual(element.frame.size, size)
        return self
    }
}

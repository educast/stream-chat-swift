//
//  ChatRobot.swift
//  StreamChatMockUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/4/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest

// MARK: Robot
protocol Robot: AnyObject { }

enum SwitchState {
    case on
    case off
}

enum ElementState {
    case enabled(isEnabled: Bool)
    case visible(isVisible: Bool)
    case focused(isFocused: Bool)

    var errorMessage: String {
        let state: String
        switch self {
        case let .enabled(isEnabled):
            state = isEnabled ? "enabled" : "disabled"
        case let .focused(isFocused):
            state = isFocused ? "in focus" : "out of focus"
        case let .visible(isVisible):
            state = isVisible ? "visible" : "hidden"
        }
        return "Element should be \(state)"
    }
}

extension Robot {

    @discardableResult
    func assertElement(_ element: XCUIElement,
                       state: ElementState,
                       file: StaticString = #file,
                       line: UInt = #line) -> Self {
        element.wait(timeout: 1.5)

        let expected: Bool
        let actual: Bool
        switch state {
        case .enabled(let isEnabled):
            expected = isEnabled
            actual = element.isEnabled
        case .focused(let isFocused):
            expected = isFocused
            actual = element.hasKeyboardFocus

        case .visible(let isVisible):
            expected = isVisible
            actual = element.exists
        }
        XCTAssertEqual(expected, actual, state.errorMessage, file: file, line: line)
        return self
    }

    /// Tap an element. Fails if it doesn't exist
    /// - Parameters:
    ///   - element: Element to tap
    ///   - file: The file in which the failure occurred. The default is the file name of the test case in which this function was called.
    ///   - line: The line number on which the failure occurred. The default is the line number on which this function was called.
    /// - Returns: instance of `Robot`
    @discardableResult
    func tap(_ element: XCUIElement, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let existence = element.wait()
        XCTAssertTrue(existence, "Element \(element.label) doesn't exist", file: file, line: line)
        if element.isEnabled {
            element.tap()
        }
        return self
    }

    /// Tap an element using it's frame. Fails if it doesn't exist
    /// - Parameters:
    ///   - element: Element to tap
    ///   - file: The file in which the failure occurred. The default is the file name of the test case in which this function was called.
    ///   - line: The line number on which the failure occurred. The default is the line number on which this function was called.
    /// - Returns: instance of `Robot`
    @discardableResult
    func tapFrameCenter(_ element: XCUIElement, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let existence = element.wait()
        XCTAssertTrue(existence, "Element \(element.label) doesn't exist", file: file, line: line)
        element.tapFrameCenter()
        return self
    }

    /// Tap an element only if it exists. No failure
    /// - Parameters:
    ///   - element: Element to tap
    ///   - file: The file in which the failure occurred. The default is the file name of the test case in which this function was called.
    ///   - line: The line number on which the failure occurred. The default is the line number on which this function was called.
    /// - Returns: instance of `Robot`
    @discardableResult
    func tapIfExists(_ element: XCUIElement, file: StaticString = #filePath, line: UInt = #line) -> Self {
        element.tapIfExists()
        return self
    }

    @discardableResult
    func obtainKeyboardFocus(for field: XCUIElement) -> Self {
        let keyboard = app.keyboards.firstMatch
        field.wait()

        if field.hasKeyboardFocus == false {
            field.tap()
        }

        if keyboard.exists == false {
            keyboard.wait()
        }
        return self
    }

    @discardableResult
    func type(_ message: String, field: XCUIElement) -> Self {
        obtainKeyboardFocus(for: field)
        field.typeText(message)
        return self
    }

    /// Removes any current text in the field before typing in the new value
    /// - Parameter text: the text to enter into the field
    @discardableResult
    func clearAndEnterText(text: String, field: XCUIElement) -> Self {
        obtainKeyboardFocus(for: field)
        field.clearAndEnterText(text: text)
        return self
    }

    /// Set text field and presses any associated button, as long as identifiers follow the same naming pattern
    ///
    /// eg. `fieldIdentifier`: `department`
    ///  textField identifier: `department.textField`
    ///  button identifier: `department.button`
    /// - Parameters:
    ///   - text: The text to insert in the field
    ///   - fieldIdentifier: indentifer
    /// - Returns: instance of `Robot`
    @discardableResult
    private func setTextField(text: String, fieldIdentifier: String) -> Self {
        let textField = app.textFields["\(fieldIdentifier).textField"]
        let button = app.buttons["\(fieldIdentifier).button"]

        if textField.text.isEmpty && text.isEmpty {
            button.tap()
            return self
        }
        type(text, field: textField)
        button.tap()
        return self
    }

    @discardableResult
    func dismissKeyboard() -> Self {
        app.swipeDown()
        return self
    }

    @discardableResult
    func tapKeyboardDoneButton() -> Self {
        app.keyboards.firstMatch.buttons["done"].tap()
        return self
    }
}

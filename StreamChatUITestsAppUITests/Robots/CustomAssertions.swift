//
//  CustomAssertions.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/16/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

@testable import StreamChatUI
import XCTest

extension Robot {
    
    @discardableResult
    func assertKeyboard(
        isVisible: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        let keyboard = app.keyboards.firstMatch
        keyboard.wait(timeout: 1.5)
        XCTAssertEqual(isVisible, keyboard.exists,
                       "Keyboard should be \(isVisible ? "visible" : "hidden")",
                       file: file,
                       line: line)
        return self
    }
    
    @discardableResult
    func assertMessage(
        _ text: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        let messageCell = MessagingPage.messageCells.firstMatch
        let message = MessagingPage.MessageAttributes.text(messageCell: messageCell)
        XCTAssertEqual(message.text, text, file: file, line: line)
        return self
    }
    
    @discardableResult
    func assertDeletedMessage(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        let messageCell = MessagingPage.messageCells.firstMatch
        let message = MessagingPage.MessageAttributes.text(messageCell: messageCell)
        let icon = MessagingPage.MessageAttributes.deletedIcon(messageCell: messageCell)
        let label = MessagingPage.MessageAttributes.deletedLabel(messageCell: messageCell)
        XCTAssertEqual(message.text, L10n.Message.deletedMessagePlaceholder, "Text is wrong", file: file, line: line)
        XCTAssertEqual(label.text, L10n.Message.onlyVisibleToYou, "Label is wrong", file: file, line: line)
        XCTAssertTrue(icon.exists, "There is no icon", file: file, line: line)
        return self
    }
    
    @discardableResult
    func assertMessageAuthor(
        _ author: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        let messageCell = MessagingPage.messageCells.firstMatch
        let actualAuthor = MessagingPage.MessageAttributes.author(messageCell: messageCell)
        XCTAssertEqual(actualAuthor.text, author, file: file, line: line)
        return self
    }
    
    @discardableResult
    func assertReaction(
        _ text: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        let messageCell = MessagingPage.messageCells.firstMatch
        let reaction = MessagingPage.MessageAttributes.reactionButton(messageCell: messageCell)
        XCTAssertTrue(reaction.exists, "There are no reactions", file: file, line: line)
        return self
    }
    
}

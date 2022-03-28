//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

@testable import StreamChatUI
import XCTest

extension Robot {
    
    @discardableResult
    func assertKeyboard(
        isVisible: Bool,
        file: StaticString = #filePath,
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
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        let messageCell = MessageListPage.cells.firstMatch
        let message = MessageListPage.Attributes.text(messageCell: messageCell)
        let actualText = message.waitForText(text).text
        XCTAssertEqual(actualText, text, file: file, line: line)
        return self
    }
    
    @discardableResult
    func assertDeletedMessage(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        let messageCell = MessageListPage.cells.firstMatch
        let message = MessageListPage.Attributes.text(messageCell: messageCell)
        let expectedMessage = L10n.Message.deletedMessagePlaceholder
        let actualMessage = message.waitForText(expectedMessage).text
        XCTAssertEqual(actualMessage, expectedMessage, "Text is wrong", file: file, line: line)
        return self
    }
    
    @discardableResult
    func assertMessageAuthor(
        _ author: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        let messageCell = MessageListPage.cells.firstMatch
        let textView = MessageListPage.Attributes.author(messageCell: messageCell)
        let actualAuthor = textView.waitForText(author).text
        XCTAssertEqual(actualAuthor, author, file: file, line: line)
        return self
    }
    
    @discardableResult
    func assertReaction(
        isPresent: Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        let messageCell = MessageListPage.cells.firstMatch
        let reaction = MessageListPage.Attributes.reactionButton(messageCell: messageCell)
        let errMessage = isPresent ? "There are no reactions" : "Reaction is presented"
        if isPresent {
            reaction.wait()
        } else {
            reaction.waitForLoss(timeout: XCUIElement.waitTimeout)
        }
        XCTAssertEqual(reaction.exists, isPresent, errMessage, file: file, line: line)
        return self
    }
    
}

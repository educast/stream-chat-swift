//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest
import StreamChat

/// Simulates user behavior
public final class UserRobot: Robot {
    
    @discardableResult
    func login() -> Self {
        StartPage.startButton.tap()
        return self
    }
    
    @discardableResult
    func openChannel() -> Self {
        ChannelListPage.cells.firstMatch.wait().tap()
        return self
    }
    
    @discardableResult
    func sendMessage(_ text: String) -> Self {
        MessageListPage.Composer.inputField.obtainKeyboardFocus().typeText(text)
        MessageListPage.Composer.sendButton.tap()
        return self
    }
    
    @discardableResult
    func deleteMessage() -> Self {
        let messageCell = MessageListPage.cells.firstMatch
        messageCell.press(forDuration: 2)
        MessageListPage.ContextMenu.delete.wait().tap()
        MessageListPage.PopUpButtons.delete.wait().tap()
        return self
    }
    
    @discardableResult
    func editMessage(_ newText: String) -> Self {
        MessageListPage.cells.firstMatch.press(forDuration: 2)
        MessageListPage.ContextMenu.edit.wait().tap()
        let inputField = MessageListPage.Composer.inputField
        inputField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        inputField.typeText(newText)
        MessageListPage.Composer.confirmButton.tap()
        return self
    }
    
    @discardableResult
    private func reactionAction(reactionType: TestData.Reactions, eventType: EventType) -> Self {
        MessageListPage.cells.firstMatch.press(forDuration: 2)
        var reaction: XCUIElement {
            switch reactionType {
            case .love:
                return MessageListPage.Reactions.love
            case .lol:
                return MessageListPage.Reactions.lol
            case .sad:
                return MessageListPage.Reactions.sad
            case .wow:
                return MessageListPage.Reactions.wow
            default:
                return MessageListPage.Reactions.like
            }
        }
        reaction.wait().tap()
        return self
    }
    
    @discardableResult
    func addReaction(type: TestData.Reactions) -> Self {
        reactionAction(reactionType: type, eventType: .reactionNew)
    }
    
    @discardableResult
    func deleteReaction(type: TestData.Reactions) -> Self {
        reactionAction(reactionType: type, eventType: .reactionDeleted)
    }
    
    // TODO:
    @discardableResult
    func replyToMessage(_ text: String) -> Self {
        return self
    }
    
    // TODO:
    @discardableResult
    func replyToMessageInThread(_ text: String, alsoSendInChannel: Bool = false) -> Self {
        return self
    }

}

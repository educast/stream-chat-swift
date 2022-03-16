//
//  ChatRobot.swift
//  StreamChatMockUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/4/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest

public final class ChatRobot: Robot {
    
    @discardableResult
    func login() -> Self {
        StartPage.startButton.tap()
        return self
    }
    
    @discardableResult
    func openChannel() -> Self {
        ChannelsPage.channelCells.firstMatch.tap()
        return self
    }
    
    @discardableResult
    func sendMessage(_ text: String) -> Self {
        MessagingPage.Composer.inputField.tapAndWaitForKeyboardToAppear().typeText(text)
        MessagingPage.Composer.sendButton.tap()
        return self
    }
    
    @discardableResult
    func deleteMessage() -> Self {
        let messageCell = MessagingPage.messageCells.firstMatch
        messageCell.press(forDuration: 1)
        MessagingPage.MessageController.delete.tap()
        MessagingPage.PopUpButtons.delete.tap()
        MessagingPage.MessageAttributes.deletedLabel(messageCell: messageCell).wait()
        return self
    }
    
    @discardableResult
    func editMessage(_ newText: String) -> Self {
        MessagingPage.messageCells.firstMatch.press(forDuration: 1)
        MessagingPage.MessageController.edit.tap()
        let inputField = MessagingPage.Composer.inputField
        inputField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        inputField.typeText(newText)
        MessagingPage.Composer.confirmButton.tap()
        return self
    }
    
    @discardableResult
    func addReaction(type: TestData.Reactions) -> Self {
        MessagingPage.messageCells.firstMatch.press(forDuration: 1)
        var reaction: XCUIElement {
            switch type {
            case .love:
                return MessagingPage.Reactions.love
            case .lol:
                return MessagingPage.Reactions.lol
            case .sad:
                return MessagingPage.Reactions.sad
            case .wow:
                return MessagingPage.Reactions.wow
            default:
                return MessagingPage.Reactions.like
            }
        }
        reaction.tap()
        return self
    }
    
    @discardableResult
    func deleteReaction(type: TestData.Reactions) -> Self {
        return addReaction(type: type)
    }
    
    @discardableResult
    func waitForParticipantsMessage() -> Self {
        let lastMessage = MessagingPage.messageCells.firstMatch
        MessagingPage.MessageAttributes.author(messageCell: lastMessage).wait()
        return self
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

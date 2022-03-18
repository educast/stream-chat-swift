//
//  MessagingTests.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/16/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

final class MessagingTests: StreamTestCase {
    
    func testSendMessage() throws {
        let message = "test message"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Send the message: '\(message)'") {
            chatRobot.sendMessage(message)
        }
        step("Assert that the message was sent") {
            chatRobot.assertMessage(message)
        }
    }

    func testEditMessage() throws {
        let message = "test message"
        let editedMessage = "hello"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Send the message: '\(message)'") {
            chatRobot.sendMessage(message)
        }
        step("Edit the message: '\(editedMessage)'") {
            chatRobot.editMessage(editedMessage)
        }
        step("Assert that the message was edited") {
            chatRobot.assertMessage(editedMessage)
        }
    }
    
    func testDeleteMessage() throws {
        let message = "test message"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Send the message: '\(message)'") {
            chatRobot.sendMessage(message)
        }
        step("Delete the message") {
            chatRobot.deleteMessage()
        }
        step("Assert that the message was deleted") {
            chatRobot.assertDeletedMessage()
        }
    }
    
    func testReceiveMessage() throws {
        let message = "test message"
        let author = "Han Solo"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Receive the message: '\(message)'") {
            participantRobot.sendMessage(message)
        }
        step("Assert that the message has come from \(author)") {
            chatRobot
                .waitForParticipantsMessage()
                .assertMessageAuthor("Han Solo")
        }
    }
    
}

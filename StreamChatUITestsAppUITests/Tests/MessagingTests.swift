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
        chatRobot
            .login()
            .openChannel()
            .sendMessage(message)
            .assertMessage(message)
    }

    func testEditMessage() throws {
        let message = "test message"
        let editedMessage = "hello"
        chatRobot
            .login()
            .openChannel()
            .sendMessage(message)
            .editMessage(editedMessage)
            .assertMessage(editedMessage)
    }
    
    func testDeleteMessage() throws {
        chatRobot
            .login()
            .openChannel()
            .sendMessage("test message")
            .deleteMessage()
            .assertDeletedMessage()
    }
    
    func testReceiveMessage() throws {
        let message = "test message"
        chatRobot
            .login()
            .openChannel()
        
        participantRobot
            .sendMessage(message)
        
        chatRobot
            .waitForParticipantsMessage()
            .assertMessageAuthor("Han Solo")
    }
    
}

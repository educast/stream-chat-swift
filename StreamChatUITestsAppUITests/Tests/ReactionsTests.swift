//
//  ReactionsTests.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/16/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

final class ReactionsTests: StreamTestCase {
    
    // TODO:
    func testAddReaction() throws {
        let message = "test message"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Send the message: '\(message)'") {
            chatRobot.sendMessage(message)
        }
        step("Add the reaction") {
            chatRobot.addReaction(type: .like)
        }
    }
    
    // TODO:
    func testDeleteReaction() throws {
        let message = "test message"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Send the message: '\(message)'") {
            chatRobot.sendMessage(message)
        }
        step("Add the reaction") {
            chatRobot.addReaction(type: .wow)
        }
        step("Add the reaction") {
            chatRobot.deleteReaction(type: .wow)
        }
    }
    
    // TODO:
    func testAddReactionToParticipantsMessage() throws {
        let message = "test message"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Receive the message: '\(message)'") {
            participantRobot.sendMessage(message)
        }
        step("Add the reaction") {
            chatRobot
                .waitForParticipantsMessage()
                .addReaction(type: .love)
        }
    }
    
    // TODO:
    func testDeleteReactionToParticipantsMessage() throws {
        let message = "test message"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Receive the message: '\(message)'") {
            participantRobot.sendMessage(message)
        }
        step("Add the reaction") {
            chatRobot
                .waitForParticipantsMessage()
                .addReaction(type: .lol)
        }
        step("Add the reaction") {
            chatRobot.deleteReaction(type: .lol)
        }
    }
    
    // TODO:
    func testParticipantAddsReaction() throws {
        let message = "test message"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Send the message: '\(message)'") {
            chatRobot.sendMessage(message)
        }
        step("Receive the reaction") {
            participantRobot.addReaction(type: .like)
        }
    }
    
    // TODO:
    func testParticipantDeletesReaction() throws {
        let message = "test message"
        
        step("Open the channel") {
            chatRobot.login().openChannel()
        }
        step("Send the message: '\(message)'") {
            chatRobot.sendMessage(message)
        }
        step("Receive the reaction") {
            participantRobot.addReaction(type: .lol)
        }
        step("Reaction was removed") {
            participantRobot.deleteReaction(type: .lol)
        }
    }
    
}

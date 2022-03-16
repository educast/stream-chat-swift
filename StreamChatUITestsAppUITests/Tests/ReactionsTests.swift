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
        chatRobot
            .login()
            .openChannel()
            .sendMessage("test message")
            .addReaction(type: .like)
    }
    
    // TODO:
    func testDeleteReaction() throws {
        chatRobot
            .login()
            .openChannel()
            .sendMessage("test message")
            .addReaction(type: .wow)
            .deleteReaction(type: .wow)
    }
    
    // TODO:
    func testAddReactionToParticipantsMessage() throws {
        chatRobot
            .login()
            .openChannel()
            .sendMessage("test message")
            .addReaction(type: .love)
    }
    
    // TODO:
    func testDeleteReactionToParticipantsMessage() throws {
        chatRobot
            .login()
            .openChannel()
        
        participantRobot
            .sendMessage("test message")
            .addReaction(type: .lol)
            .deleteReaction()
    }
    
}

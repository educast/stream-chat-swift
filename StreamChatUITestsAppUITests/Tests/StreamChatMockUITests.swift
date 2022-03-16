//
//  StreamChatMockUITests.swift
//  StreamChatMockUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/3/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

final class StreamChatMockUITests: StreamTestCase {

    func testStreamDemoApp() throws {
        chatRobot
            .login()
            .openChat("The water cooler")
            .sendMessage("Hello my friend!")
        
        companionRobot
            .startTyping()
            .stopTyping()
            .sendMessage("Howaya?")
    }
    
}

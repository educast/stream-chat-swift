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
        ChatRobot()
            .login()
            .openChat()
            .sendMessage("Hello my friend!")
        
        server.sendMessage()
        sleep(100)
    }
    
}

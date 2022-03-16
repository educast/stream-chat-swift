//
//  ChatRobot.swift
//  StreamChatMockUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/4/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation

public final class ChatRobot: Robot {
    
    var server: StreamMockServer
    
    init(_ server: StreamMockServer) {
        self.server = server
    }
    
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
    func notifyMessageRead() -> Self { // FIXME
        server.writeText(TestData.getMockResponse(fromFile: "http_notification_read"))
        return self
    }

}

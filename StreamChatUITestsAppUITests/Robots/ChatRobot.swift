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
        app.buttons["TestApp.Start"].tap()
        return self
    }
    
    @discardableResult
    func openChat(_ name: String) -> Self {
        let predicate = NSPredicate(format: "label LIKE '\(name)'")
        app.otherElements.staticTexts.matching(predicate).firstMatch.tap()
        return self
    }
    
    @discardableResult
    func sendMessage(_ text: String) -> Self {
        sleep(3) // FIXME
        app.otherElements.textViews.lastMatch?.tap()
        app.otherElements.textViews.lastMatch?.typeText(text)
        let predicate = NSPredicate(format: "label LIKE 'arrow send'")
        app.buttons.matching(predicate).firstMatch.tap()
        return self
    }
    
    @discardableResult
    func notifyMessageRead() -> Self { // FIXME
        server.writeText(TestData.getMockResponse(fromFile: "mock_send_notification_read"))
        return self
    }

}

//
//  ChatRobot.swift
//  StreamChatMockUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/4/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation

public final class ChatRobot: Robot {
    
    @discardableResult
    func login(_ name: String) -> Self {
        let predicate = NSPredicate(format: "label LIKE '\(name)'")
        app.cells.staticTexts.matching(predicate).firstMatch.tap()
        return self
    }
    
    @discardableResult
    func openChat() -> Self {
        let predicate = NSPredicate(format: "label LIKE 'Adella and Luke Skywalker'")
        app.otherElements.staticTexts.matching(predicate).firstMatch.tap()
        return self
    }
    
    @discardableResult
    func sendMessage(_ text: String) -> Self {
        app.otherElements.textViews.lastMatch?.tap()
        app.otherElements.textViews.lastMatch?.typeText(text)
        let predicate = NSPredicate(format: "label LIKE 'arrow send'")
        app.buttons.matching(predicate).firstMatch.tap()
        return self
    }

}

//
//  ThreadPage.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/14/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest

class ThreadPage: MessagingPage {
    
    static var alsoSendInChannelCheckbox: XCUIElement { app.otherElements["CheckboxControl"] }
    
    final class NavigationBar {
        
        static var header: XCUIElement { app.otherElements["ChatThreadHeaderView"] }
        
        static var channelName: XCUIElement {
            header.staticTexts.lastMatch!
        }
    }
    
}

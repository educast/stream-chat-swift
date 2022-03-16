//
//  ChannelsPage.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/11/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest

enum ChannelsPage {
    
    static var userAvatar: XCUIElement { app.otherElements["CurrentChatUserAvatarView"] }
    
    static var channelCells: XCUIElementQuery {
        app.cells.matching(NSPredicate(format: "identifier LIKE 'ChatChannelListCollectionViewCell'"))
    }
    
    final class ChannelAttributes {
        static func name(channelCell: XCUIElement) -> XCUIElement {
            channelCell.staticTexts.firstMatch // FIXME
        }
        
        static func lastMessageTime(channelCell: XCUIElement) -> XCUIElement {
            channelCell.staticTexts.firstMatch // FIXME
        }
        
        static func lastMessage(channelCell: XCUIElement) -> XCUIElement {
            channelCell.staticTexts.firstMatch // FIXME
        }
        
        static func avatar(channelCell: XCUIElement) -> XCUIElement {
            channelCell.otherElements["ChatAvatarView"].images.firstMatch
        }
    }

}

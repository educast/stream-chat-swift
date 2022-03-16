//
//  MessagingPage.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/11/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
import XCTest

class MessagingPage {
    
    static var messageCells: XCUIElementQuery {
        app.cells.matching(NSPredicate(format: "identifier LIKE 'ChatMessageCell'"))
    }
    
    final class NavigationBar {
        
        static var header: XCUIElement { app.otherElements["ChatChannelHeaderView"] }
        
        static var chatAvatar: XCUIElement {
            app.otherElements["ChatAvatarView"].images.firstMatch
        }
        
        static var chatName: XCUIElement {
            app.staticTexts.firstMatch // FIXME
        }
        
        static var participantsCount: XCUIElement {
            app.staticTexts.firstMatch // FIXME
        }
        
        static var participantsStatus: XCUIElement {
            app.staticTexts.firstMatch // FIXME
        }
    }
    
    final class Composer {
        static var sendButton: XCUIElement { app.buttons["SendButton"] }
        static var attachmentButton: XCUIElement { app.buttons["AttachmentButton"] }
        static var commandButton: XCUIElement { app.buttons["CommandButton"] }
        static var inputField: XCUIElement { app.otherElements["InputChatMessageView"] }
    }
    
    
    final class Reactions {
        static var lol: XCUIElement { reaction(label: "reaction lol big") }
        static var thumbsUp: XCUIElement { reaction(label: "reaction thumbsup big") }
        static var love: XCUIElement { reaction(label: "reaction love big") }
        static var thumbsDown: XCUIElement { reaction(label: "reaction thumbsdown big") }
        static var wut: XCUIElement { reaction(label: "reaction wut big") }
        
        private static var id = "ChatMessageReactionItemView"
        
        private static func reaction(label: String) -> XCUIElement {
            let predicate = NSPredicate(
                format: "identifier LIKE '\(id)' AND label LIKE '\(label)'"
            )
            return app.buttons.matching(predicate).firstMatch
        }
    }
    
    final class MessageController {
        static var reply: XCUIElement { action(label: "Reply") }
        static var threadReply: XCUIElement { action(label: "Thread Reply") }
        static var copy: XCUIElement { action(label: "Copy Message") }
        static var flag: XCUIElement { action(label: "Flag Message") }
        static var muteUser: XCUIElement { action(label: "Mute User") }
        static var edit: XCUIElement { action(label: "Edit Message") }
        static var delete: XCUIElement { action(label: "Delete Message") }
        
        private static var id = "ChatMessageActionControl"
        
        private static func action(label: String) -> XCUIElement {
            let predicate = NSPredicate(format: "label LIKE '\(label)'")
            return app.otherElements[id].staticTexts.matching(predicate).firstMatch
        }
    }
    
    final class MessageAttributes { // FIXME
        static func threadButton(messageCell: XCUIElement) -> XCUIElement {
            messageCell.buttons.firstMatch
        }
        
        static func time(messageCell: XCUIElement) -> XCUIElement {
            messageCell.staticTexts.firstMatch
        }
        
        static func author(messageCell: XCUIElement) -> XCUIElement {
            messageCell.staticTexts.firstMatch
        }
        
        static func text(messageCell: XCUIElement) -> XCUIElement {
            messageCell.textViews.firstMatch
        }
    }
    
    final class AttachmentsController {
        static var fileButton: XCUIElement {
            app.scrollViews.buttons.matching(NSPredicate(format: "label LIKE 'File'")).firstMatch
        }
        
        static var photoOrVideoButton: XCUIElement {
            app.scrollViews.buttons.matching(NSPredicate(format: "label LIKE 'Photo or Video'")).firstMatch
        }
        
        static var cancelButton: XCUIElement {
            app.scrollViews.buttons.matching(NSPredicate(format: "label LIKE 'Cancel'")).firstMatch
        }
    }
    
    final class CommandsController {
        static var commandCells: XCUIElementQuery {
            app.cells.matching(NSPredicate(format: "identifier LIKE 'ChatCommandSuggestionCollectionViewCell'"))
        }
        
        static var headerTitle: XCUIElement {
            app.otherElements["ChatSuggestionsHeaderView"].staticTexts.firstMatch
        }
        
        static var headerImage: XCUIElement {
            app.otherElements["ChatSuggestionsHeaderView"].images.firstMatch
        }
        
        static var gipthyImage: XCUIElement {
            app.images["command_giphy"]
        }
    }
    
}

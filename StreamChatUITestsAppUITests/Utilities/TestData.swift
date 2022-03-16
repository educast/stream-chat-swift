//
//  TestData.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/10/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

@testable import StreamChat
import Swifter
import XCTest

enum TestData {
    
    static var uniqueId: String { UUID().uuidString }
    static var currentDate: String { try! XCTUnwrap(DateFormatter.Stream.rfc3339DateString(from: Date())) }
    
    static func getMockResponse(fromFile file: MockFiles) -> String {
        String(decoding: XCTestCase.mockData(fromFile: file.rawValue), as: UTF8.self)
    }
    
    static func mockData(fromFile file: MockFiles) -> [UInt8] {
        [UInt8](XCTestCase.mockData(fromFile: file.rawValue))
    }
    
    static func toJson(_ requestBody: [UInt8]) -> [String: Any] {
        String(bytes: requestBody, encoding: .utf8)!.json
    }
    
    static func toJson(_ file: MockFiles) -> [String: Any] {
        toJson(mockData(fromFile: file))
    }
    
    final class MockServerDetails {
        static var port = Int.random(in: 61000..<62000)
        static var websocketHost = "ws://localhost"
        static var httpHost = "http://localhost"
    }
    
    enum Reactions: String {
        case love
        case lol = "haha"
        case wow
        case sad
        case like
    }
    
    enum MockFiles: String {
        case httpMessageSent = "http_message_sent"
        case httpMessageRead = "http_message_read"
        case httpMessageDeleted = "http_message_deleted"
        case httpTypingStart = "http_typing_start"
        case httpTypingStop = "http_typing_stop"
        case httpReactionAdded = "http_reaction_added"
        case httpReactionDeleted = "http_reaction_deleted"
        case wsMessageSent = "ws_message_sent"
        case wsMessageRead = "ws_message_read"
        case wsMessageDeleted = "ws_message_deleted"
        case wsTypingStart = "ws_typing_start"
        case wsTypingStop = "ws_typing_stop"
        case wsReactionAdded = "ws_reaction_added"
        case wsReactionDeleted = "ws_reaction_deleted"
        case wsHealthCheck = "HealthCheck"
        case httpChannel = "Channel"
        case httpChannelsQuery = "ChannelsQuery"
    }
    
    enum JsonKeys: String {
        case message
        case reaction
        case event
    }
    
}

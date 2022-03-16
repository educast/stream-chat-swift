//
//  ParticipantRobot.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/10/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

@testable import StreamChat
import Swifter
import XCTest

public final class ParticipantRobot: Robot {
    
    var server: StreamMockServer
    
    init(_ server: StreamMockServer) {
        self.server = server
    }
    
    @discardableResult
    func startTyping() -> Self {
        let json = TestData.getMockResponse(fromFile: "ws_typing_start")
        server.writeText(json)
        return self
    }
    
    @discardableResult
    func stopTyping() -> Self {
        let json = TestData.getMockResponse(fromFile: "ws_typing_stop")
        server.writeText(json)
        return self
    }
    
    @discardableResult
    func sendMessage(_ text: String) -> Self {
        var json = TestData.getMockResponse(fromFile: "ws_new_message").json
        var message = json["message"] as! Dictionary<String, Any>
        let timestamp: String = TestData.currentDate
        message["created_at"] = timestamp
        message["updated_at"] = timestamp
        message["html"] = "<p>\(text)</p>\n"
        message["text"] = text
        message["id"] = TestData.uniqueId
        json["message"] = message
        server.writeText(json.jsonToString())
        return self
    }
    
    @discardableResult
    func readMessage() -> Self {
        server.writeText(TestData.getMockResponse(fromFile: "ws_message_read"))
        return self
    }

}

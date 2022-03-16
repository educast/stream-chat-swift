//
//  StreamMockServer.swift
//  StreamMockServer
//
//  Created by Alexey Alter Pesotskiy  on 3/3/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

@testable import StreamChat
import Swifter

final class StreamMockServer {
    
    private var server: HttpServer = HttpServer()
    private weak var globalSession: WebSocketSession?
    public var latestMessageId: String?
    public var latestMessageText: String?
    public var latestMessageTimestamp: String?
    
    func start(port: UInt16) {
        do {
            try server.start(port)
            print("Server status: \(server.state). Port: \(port)")
        } catch {
            print("Server start error: \(error)")
        }
    }
    
    func stop() {
        server.stop()
    }

    func configure() {
        server["/connect"] = webSocketClosure()
        server["/channels/messaging/:channel_id/message"] = { request in
            self.messageCreation(request: request)
        }
        server["/channels/messaging/:channel_id/event"] = { request in
            self.newEvent(request: request)
        }
        // TODO:
        server["/channels/messaging/:channel_id/query"] = { _ in
            .ok(.text(TestData.getMockResponse(fromFile: .httpChannel)))
        }
        // TODO:
        server["/channels"] = { _ in
            .ok(.text(TestData.getMockResponse(fromFile: .httpChannelsQuery)))
        }
        server["/channels/messaging/:channel_id/read"] = { request in
            self.readMessage(request: request)
        }
        server["/messages/:message_id"] = { request in
            self.editMessage(request: request)
        }
        server["/messages/:message_id/reaction"] = { request in
            self.reactionCreation(request: request)
        }
        server["/messages/:message_id/reaction/:reaction_type"] = { request in
            self.reactionDeletion(request: request)
        }
    }
    
    func writeText(_ text: String) {
        globalSession?.writeText(text)
    }
    
    func saveMessageInfo(messageId: Any?, timestamp: String, text: Any?) {
        latestMessageId = messageId as? String
        latestMessageTimestamp = timestamp
        latestMessageText = text as? String
    }
    
    private func webSocketClosure() -> ((HttpRequest) -> HttpResponse) {
        websocket(connected: { [weak self] session in
            self?.globalSession = session
            self?.onConnect()
        }, disconnected: { [weak self] _ in
            self?.globalSession = nil
        })
    }
    
    // TODO:
    private func onConnect() {
        writeText(TestData.getMockResponse(fromFile: .wsHealthCheck))
    }
    
    private func messageCreation(request: HttpRequest) -> HttpResponse {
        let requestJson = TestData.toJson(request.body)
        let messageKey = TestData.JsonKeys.message.rawValue
        let requestMessage = requestJson[messageKey] as! Dictionary<String, Any>
        let text = requestMessage[MessagePayloadsCodingKeys.text.rawValue]!
        let id = requestMessage[MessagePayloadsCodingKeys.id.rawValue]
        var responseJson = TestData.toJson(.httpMessageSent)
        var responseMessage = responseJson[messageKey] as! Dictionary<String, Any>
        let timestamp: String = TestData.currentDate
        responseMessage[MessagePayloadsCodingKeys.createdAt.rawValue] = timestamp
        responseMessage[MessagePayloadsCodingKeys.updatedAt.rawValue] = timestamp
        responseMessage[MessagePayloadsCodingKeys.id.rawValue] = id
        responseMessage[MessagePayloadsCodingKeys.text.rawValue] = text
        responseMessage[MessagePayloadsCodingKeys.html.rawValue] = "\(text)".html
        responseJson[messageKey] = responseMessage
        saveMessageInfo(messageId: id, timestamp: timestamp, text: text)
        return .ok(.json(responseJson))
    }
    
    private func editMessage(request: HttpRequest) -> HttpResponse {
        if request.method == EndpointMethod.delete.rawValue {
            return messageDeletion(request: request)
        } else {
            return messageCreation(request: request)
        }
    }
    
    private func messageDeletion(request: HttpRequest) -> HttpResponse {
        var json = TestData.toJson(.httpMessageDeleted)
        let messageKey = TestData.JsonKeys.message.rawValue
        var message = json[messageKey] as! Dictionary<String, Any>
        message[MessagePayloadsCodingKeys.createdAt.rawValue] = latestMessageTimestamp
        message[MessagePayloadsCodingKeys.updatedAt.rawValue] = latestMessageTimestamp
        message[MessagePayloadsCodingKeys.deletedAt.rawValue] = TestData.currentDate
        message[MessagePayloadsCodingKeys.id.rawValue] = latestMessageId
        message[MessagePayloadsCodingKeys.text.rawValue] = latestMessageText
        message[MessagePayloadsCodingKeys.html.rawValue] = latestMessageText?.html
        json[messageKey] = message
        return .ok(.json(json))
    }
    
    private func reactionCreation(request: HttpRequest) -> HttpResponse {
        let messageId = request.params[":message_id"]
        let requestJson = TestData.toJson(request.body)
        let messageKey = TestData.JsonKeys.message.rawValue
        let reactionKey = TestData.JsonKeys.reaction.rawValue
        let requestReaction = requestJson[reactionKey] as! Dictionary<String, Any>
        var responseJson = TestData.toJson(.httpReactionAdded)
        var responseMessage = responseJson[messageKey] as! Dictionary<String, Any>
        var responseReaction = responseJson[reactionKey] as! Dictionary<String, Any>
        let timestamp: String = TestData.currentDate
        responseMessage[MessagePayloadsCodingKeys.createdAt.rawValue] = latestMessageTimestamp
        responseMessage[MessagePayloadsCodingKeys.updatedAt.rawValue] = latestMessageTimestamp
        responseMessage[MessagePayloadsCodingKeys.id.rawValue] = messageId
        responseMessage[MessagePayloadsCodingKeys.text.rawValue] = latestMessageText
        responseMessage[MessagePayloadsCodingKeys.html.rawValue] = latestMessageText?.html
        responseJson[messageKey] = responseMessage
        
        let codingKeys = MessageReactionPayload.CodingKeys.self
        responseReaction[codingKeys.messageId.rawValue] = messageId
        responseReaction[codingKeys.type.rawValue] = requestReaction[codingKeys.type.rawValue]
        responseMessage[codingKeys.createdAt.rawValue] = timestamp
        responseMessage[codingKeys.updatedAt.rawValue] = timestamp
        responseJson[reactionKey] = responseReaction
        return .ok(.json(responseJson))
    }
    
    private func reactionDeletion(request: HttpRequest) -> HttpResponse {
        let messageId = request.params[":message_id"]
        let reactionType = request.params[":reaction_type"]
        var json = TestData.toJson(.httpReactionAdded)
        let messageKey = TestData.JsonKeys.message.rawValue
        let reactionKey = TestData.JsonKeys.reaction.rawValue
        var message = json[messageKey] as! Dictionary<String, Any>
        var reaction = json[reactionKey] as! Dictionary<String, Any>
        let timestamp: String = TestData.currentDate
        
        message[MessagePayloadsCodingKeys.createdAt.rawValue] = latestMessageTimestamp
        message[MessagePayloadsCodingKeys.updatedAt.rawValue] = latestMessageTimestamp
        message[MessagePayloadsCodingKeys.id.rawValue] = messageId
        message[MessagePayloadsCodingKeys.text.rawValue] = latestMessageText
        message[MessagePayloadsCodingKeys.html.rawValue] = latestMessageText?.html
        json[messageKey] = message
        
        let codingKeys = MessageReactionPayload.CodingKeys.self
        reaction[codingKeys.messageId.rawValue] = messageId
        reaction[codingKeys.type.rawValue] = reactionType
        reaction[codingKeys.createdAt.rawValue] = timestamp
        reaction[codingKeys.updatedAt.rawValue] = timestamp
        json[reactionKey] = reaction
        return .ok(.json(json))
    }
    
    private func newEvent(request: HttpRequest) -> HttpResponse {
        let json = TestData.toJson(request.body)
        let eventKey = TestData.JsonKeys.event.rawValue
        let event = json[eventKey] as! Dictionary<String, Any>
        let mockFile = { () -> TestData.MockFiles in
            switch event[EventPayload.CodingKeys.eventType.rawValue] as! String {
            case EventType.userStartTyping.rawValue:
                return .httpTypingStart
            case EventType.userStopTyping.rawValue:
                return .httpTypingStop
            default:
                return .httpTypingStop
            }
        }
        var responseJson = TestData.toJson(mockFile())
        var responseEvent = responseJson[eventKey] as! Dictionary<String, Any>
        responseEvent[EventPayload.CodingKeys.createdAt.rawValue] = TestData.currentDate
        responseJson[eventKey] = responseEvent
        return .ok(.json(responseJson))
    }
    
    private func readMessage(request: HttpRequest) -> HttpResponse {
        var json = TestData.toJson(.httpMessageRead)
        let eventKey = TestData.JsonKeys.event.rawValue
        var event = json[eventKey] as! Dictionary<String, Any>
        event[EventPayload.CodingKeys.createdAt.rawValue] = TestData.currentDate
        json[eventKey] = event
        return .ok(.json(json))
    }
}

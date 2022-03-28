//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

@testable import StreamChat
import Foundation
import Swifter

extension StreamMockServer {
    
    /// Delays websocket so that http response arrives first
    ///
    /// - Parameters: Void
    /// - Returns: Self
    func websocketDelay(closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            closure()
        }
    }
    
    /// Sends an event over a websocket connection
    ///
    /// - Parameters: EventType
    /// - Returns: Self
    @discardableResult
    func websocketEvent(
        _ eventType: EventType,
        user: [String : Any]
    ) -> Self {
        var json = TestData.getMockResponse(fromFile: .wsChatEvent).json
        json[EventPayload.CodingKeys.user.rawValue] = user
        json[EventPayload.CodingKeys.createdAt.rawValue] = TestData.currentDate
        json[EventPayload.CodingKeys.eventType.rawValue] = eventType.rawValue
        writeText(json.jsonToString())
        return self
    }
    
    /// Manages the lifecycle of the messages over a websocket connection
    ///
    /// - Parameters:
    ///     - String: the text that will be used in the message (empty by default for deleted messages)
    ///     - EventType: what needs to be done with message
    /// - Returns: Self
    @discardableResult
    func websocketMessage(
        _ text: String = "",
        messageId: String = "",
        timestamp: String = "",
        eventType: EventType,
        user: [String : Any]
    ) -> Self {
        var json = TestData.getMockResponse(fromFile: .wsMessage).json
        let message = json[TopLevelKey.message] as! [String: Any]
        let updatedAt: String = timestamp.isEmpty ? TestData.currentDate : timestamp
        var mockedMessage: [String: Any]
        
        switch eventType {
        case .messageNew:
            let id = messageId.isEmpty ? TestData.uniqueId : messageId
            mockedMessage = mockMessage(
                message,
                messageId: id,
                text: text,
                createdAt: updatedAt,
                updatedAt: updatedAt
            )
            mockedMessage[MessagePayloadsCodingKeys.user.rawValue] = user
            saveMessage(mockedMessage)
        case .messageDeleted:
            let messageDetails = messageId.isEmpty ? findMessage() : findMessage(id: messageId)
            mockedMessage = mockDeletedMessage(messageDetails)
            let id = messageDetails[MessagePayloadsCodingKeys.id.rawValue] as! String
            removeMessage(id: id)
        case .messageUpdated:
            let messageDetails = messageId.isEmpty ? findMessage() : findMessage(id: messageId)
            mockedMessage = mockMessage(
                message,
                messageId: messageDetails[MessagePayloadsCodingKeys.id.rawValue] as! String?,
                text: text,
                createdAt: messageDetails[MessagePayloadsCodingKeys.createdAt.rawValue] as! String?,
                updatedAt: updatedAt
            )
            saveMessage(mockedMessage)
        default:
            mockedMessage = [:]
        }
        
        json[TopLevelKey.user] = user
        json[TopLevelKey.message] = mockedMessage
        json[MessagePayloadsCodingKeys.createdAt.rawValue] = TestData.currentDate
        json[MessagePayloadsCodingKeys.type.rawValue] = eventType.rawValue
        writeText(json.jsonToString())
        return self
    }
    
    /// Manages the lifecycle of the reactions over a websocket connection
    ///
    /// - Parameters:
    ///     - TestData.Reactions: the reaction that will be used
    ///     - EventType: what needs to be done with reaction
    /// - Returns: Self
    @discardableResult
    func websocketReaction(
        type: TestData.Reactions,
        eventType: EventType,
        user: [String : Any]
    ) -> Self {
        let messageDetails = findMessage()
        var json = TestData.getMockResponse(fromFile: .wsReaction).json
        var reaction = json[TopLevelKey.reaction] as! [String: Any]
        var message = json[TopLevelKey.message] as! [String: Any]
        let messageId = messageDetails[MessagePayloadsCodingKeys.id.rawValue] as! String?
        let timestamp = TestData.currentDate
        
        message = mockMessageWithReaction(
            messageDetails,
            fromUser: user,
            reactionType: type.rawValue,
            timestamp: timestamp,
            deleted: eventType == .reactionDeleted
        )
        
        reaction = mockReaction(
            reaction,
            fromUser: user,
            messageId: messageId,
            reactionType: type.rawValue,
            timestamp: timestamp
        )
        
        json[TopLevelKey.message] = message
        json[TopLevelKey.reaction] = reaction
        json[MessageReactionPayload.CodingKeys.user.rawValue] = user
        json[MessageReactionPayload.CodingKeys.createdAt.rawValue] = TestData.currentDate
        json[MessageReactionPayload.CodingKeys.type.rawValue] = eventType.rawValue
        
        writeText(json.jsonToString())
        return self
    }
}

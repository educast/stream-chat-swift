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
        var json = TestData.getMockResponse(fromFile: .wsTypingStart).json
        json[MessagePayloadsCodingKeys.createdAt.rawValue] = TestData.currentDate
        server.writeText(json.jsonToString())
        return self
    }
    
    @discardableResult
    func stopTyping() -> Self {
        var json = TestData.getMockResponse(fromFile: .wsTypingStop).json
        json[MessagePayloadsCodingKeys.createdAt.rawValue] = TestData.currentDate
        server.writeText(json.jsonToString())
        return self
    }
    
    @discardableResult
    func sendMessage(_ text: String) -> Self {
        var json = TestData.getMockResponse(fromFile: .wsMessageSent).json
        let messageKey = TestData.JsonKeys.message.rawValue
        var message = json[messageKey] as! Dictionary<String, Any>
        let timestamp: String = TestData.currentDate
        let messageId = TestData.uniqueId
        message[MessagePayloadsCodingKeys.createdAt.rawValue] = timestamp
        message[MessagePayloadsCodingKeys.updatedAt.rawValue] = timestamp
        message[MessagePayloadsCodingKeys.html.rawValue] = text.html
        message[MessagePayloadsCodingKeys.text.rawValue] = text
        message[MessagePayloadsCodingKeys.id.rawValue] = messageId
        json[messageKey] = message
        
        server.writeText(json.jsonToString())
        server.cacheMessage(messageId: messageId, timestamp: timestamp, text: text)
        return self
    }
    
    @discardableResult
    func readMessage() -> Self {
        var json = TestData.getMockResponse(fromFile: .wsMessageRead).json
        json[MessagePayloadsCodingKeys.createdAt.rawValue] = TestData.currentDate
        server.writeText(json.jsonToString())
        return self
    }
    
    // TODO:
    @discardableResult
    func deleteMessage() -> Self {
        return self
    }
    
    // TODO:
    @discardableResult
    func editMessage() -> Self {
        return self
    }
    
    @discardableResult
    func addReaction(type: TestData.Reactions) -> Self {
        let messageDetails = server.messagingHistory.last!
        var json = TestData.getMockResponse(fromFile: .wsReactionAdded).json
        let messageKey = TestData.JsonKeys.message.rawValue
        let reactionKey = TestData.JsonKeys.reaction.rawValue
        var reaction = json[reactionKey] as! Dictionary<String, Any>
        var message = json[messageKey] as! Dictionary<String, Any>
        let latestReactionsKey = MessagePayloadsCodingKeys.latestReactions.rawValue
        let reactionsCountsKey = MessagePayloadsCodingKeys.reactionScores.rawValue
        let reactionsScoresKey = MessagePayloadsCodingKeys.reactionScores.rawValue
        var latest_reactions = message[latestReactionsKey] as! Array<Dictionary<String, Any>>
        var reaction_counts = message[reactionsCountsKey] as! Dictionary<String, Any>
        var reaction_scores = message[reactionsScoresKey] as! Dictionary<String, Any>
        let currentTimestamp = TestData.currentDate
        let codingKeys = MessageReactionPayload.CodingKeys.self
        
        reaction[codingKeys.type.rawValue] = type.rawValue
        reaction[ChannelCodingKeys.createdAt.rawValue] = currentTimestamp
        reaction[codingKeys.messageId.rawValue] = messageDetails["messageId"]
        reaction_counts[type.rawValue] = 1
        reaction_scores[type.rawValue] = 1
        
        for (index, _) in latest_reactions.enumerated() {
            latest_reactions[index][codingKeys.type.rawValue] = type.rawValue
            latest_reactions[index][codingKeys.messageId.rawValue] = messageDetails["messageId"]
            latest_reactions[index][codingKeys.createdAt.rawValue] = currentTimestamp
        }
        
        message[MessagePayloadsCodingKeys.id.rawValue] = messageDetails["messageId"]
        message[MessagePayloadsCodingKeys.createdAt.rawValue] = messageDetails["timestamp"]
        message[MessagePayloadsCodingKeys.text.rawValue] = messageDetails["text"]
        message[MessagePayloadsCodingKeys.html.rawValue] = messageDetails["text"]?.html
        message[MessagePayloadsCodingKeys.latestReactions.rawValue] = latest_reactions
        message[reactionsCountsKey] = reaction_counts
        message[reactionsScoresKey] = reaction_scores
        
        json[messageKey] = message
        json[reactionKey] = reaction
        
        server.writeText(json.jsonToString())
        return self
    }
    
    // TODO:
    @discardableResult
    func deleteReaction(type: TestData.Reactions) -> Self {
        return self
    }
    
    // TODO:
    @discardableResult
    func replyToMessage(_ text: String) -> Self {
        return self
    }
    
    // TODO:
    @discardableResult
    func replyToMessageInThread(_ text: String, alsoSendInChannel: Bool = false) -> Self {
        return self
    }

}

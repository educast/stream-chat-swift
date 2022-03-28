//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

@testable import StreamChat
import Swifter

extension StreamMockServer {
    
    // TODO: CIS-1686
    func configureChannelEndpoints() {
        server[MockEndpoint.query] = { _ in
            self.buildChannelsList()
        }
        server[MockEndpoint.channels] = { _ in
            self.buildChannelQuery()
        }
    }
    
    // TODO: CIS-1686
    func buildChannelQuery() -> HttpResponse {
        var json = TestData.toJson(.httpChannelQuery)
        var channels = json[TopLevelKey.channels] as! [[String: Any]]
        channels[0][ChannelQuery.CodingKeys.messages.rawValue] = messageList
        json[TopLevelKey.channels] = channels
        return .ok(.json(json))
    }
    
    // TODO: CIS-1686
    func buildChannelsList() -> HttpResponse {
        var json = TestData.toJson(.httpChannels)
        var channels = json[TopLevelKey.channels] as! [[String: Any]]
        channels[0][ChannelQuery.CodingKeys.messages.rawValue] = messageList
        json[TopLevelKey.channels] = channels
        return .ok(.json(json))
    }
}

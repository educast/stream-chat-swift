//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
@testable import StreamChat

public class ChatUserSearchControllerMock: ChatUserSearchController {
    public static func mock() -> ChatUserSearchControllerMock {
        .init(client: .mock())
    }
    
    public var users_mock: [ChatUser]?
    override public var userArray: [ChatUser] {
        users_mock ?? super.userArray
    }
}

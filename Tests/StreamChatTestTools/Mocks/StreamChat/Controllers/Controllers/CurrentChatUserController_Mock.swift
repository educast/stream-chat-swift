//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
@testable import StreamChat

public class CurrentChatUserControllerMock: CurrentChatUserController {
    public static func mock() -> CurrentChatUserControllerMock {
        .init(client: .mock())
    }
    
    public var currentUser_mock: CurrentChatUser?
    override public var currentUser: CurrentChatUser? {
        currentUser_mock
    }
}

//
//  LaunchArgument.swift
//  StreamChatMockUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/9/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation

enum LaunchArgument: String {
    case useMockServer = "USE_MOCK_SERVER"
}

enum EnvironmentVariable: String {
    case websocketHost = "MOCK_SERVER_WEBSOCKET_HOST"
    case httpHost = "MOCK_SERVER_HTTP_HOST"
    case port = "MOCK_SERVER_PORT"
}

extension ProcessInfo {
    static func contains(_ argument: LaunchArgument) -> Bool {
        processInfo.arguments.contains(argument.rawValue)
    }

    static subscript(_ environmentVariable: EnvironmentVariable) -> String? {
        processInfo.environment[environmentVariable.rawValue]
    }
}

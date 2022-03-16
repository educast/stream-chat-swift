//
//  StreamTestCase.swift
//  StreamChatMockUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/9/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import XCTest

let app = XCUIApplication()

class StreamTestCase: XCTestCase {

    let chatRobot = ChatRobot()
    let deviceRobot = DeviceRobot()
    var server: StreamMockServer!

    override func setUpWithError() throws {
        continueAfterFailure = false
        server = StreamMockServer()
        server.configure()
        server.start(port: in_port_t(8889))

        try super.setUpWithError()
        app.setLaunchArguments(.useMockServer)
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        server.stop()
        server = nil
        
        try super.tearDownWithError()
        app.launchArguments.removeAll()
        app.launchEnvironment.removeAll()
    }
}

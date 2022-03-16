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

    let deviceRobot = DeviceRobot()
    var chatRobot: ChatRobot!
    var participantRobot: ParticipantRobot!
    var server: StreamMockServer!
    static var swizzledOutIdle = false

    override func setUpWithError() throws {
        continueAfterFailure = false
        server = StreamMockServer()
        server.configure()
        server.start(port: in_port_t(TestData.MockServerDetails.port))
        chatRobot = ChatRobot(server)
        participantRobot = ParticipantRobot(server)

        try super.setUpWithError()
        app.setLaunchArguments(.useMockServer)
        app.setEnvironmentVariables([
            .websocketHost: "\(TestData.MockServerDetails.websocketHost)",
            .httpHost: "\(TestData.MockServerDetails.httpHost)",
            .port: "\(TestData.MockServerDetails.port)"
        ])
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

//
//  TestData.swift
//  StreamChatUITestsAppUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/10/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

@testable import StreamChat
import XCTest

enum TestData {
    
    static var uniqueId: String { UUID().uuidString }
    static var currentDate: String { try! XCTUnwrap(DateFormatter.Stream.rfc3339DateString(from: Date())) }
    
    static func getMockResponse(fromFile file: String) -> String {
        return String(decoding: XCTestCase.mockData(fromFile: file), as: UTF8.self)
    }
    
    final class MockServerDetails {
        static var port = Int.random(in: 61000..<62000)
        static var websocketHost = "ws://localhost"
        static var httpHost = "http://localhost"
    }
    
}

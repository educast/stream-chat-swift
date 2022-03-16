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
    
    func webSocketClosure() -> ((HttpRequest) -> HttpResponse) {
        websocket(text: { [weak self] (_, text) in
            self?.websocketResponse(text)
        }, binary: { session, binary in
            session.writeBinary(binary)
        }, connected: { [weak self] session in
            print("New client connected")
            self?.globalSession = session
            self?.onConnect()
        }, disconnected: { [weak self] _ in
            print("Client disconnected")
            self?.globalSession = nil
        })
    }
    
    func writeText(_ text: String) {
        globalSession?.writeText(text)
    }
    
    func onConnect() {
        writeText(TestData.getMockResponse(fromFile: "HealthCheck"))
    }
    
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
    
    // Client -> Server
    private func websocketResponse(_ text: String) {
        print("Client send text: \(text)")
    }

    func configure() {
        server["/connect"] = webSocketClosure()
        server["/channels/messaging/:channel_id/message"] = { request in
            self.sendMessage(request: request)
        }
        server["/channels/messaging/:channel_id/event"] = { request in
            self.sendEvent(request: request)
        }
        server["/channels/messaging/:channel_id/query"] = { _ in // FIXME
            .ok(.text(TestData.getMockResponse(fromFile: "Channel")))
        }
        server["/channels"] = { _ in
            .ok(.text(TestData.getMockResponse(fromFile: "ChannelsQuery")))
        }
        server["/channels/messaging/:channel_id/read"] = { request in
            self.readMessage(request: request)
        }
    }
    
    private func sendMessage(request: HttpRequest) -> HttpResponse {
        let requestJson = String(bytes: request.body, encoding: .utf8)!.json
        let requestMessage = requestJson["message"] as! Dictionary<String, Any>
        let text = requestMessage["text"]
        let id = requestMessage["id"]
        var responseJson = String(
            bytes: XCTestCase.mockData(fromFile: "mock_send_new_message"),
            encoding: .utf8
        )!.json
        var responseMessage = responseJson["message"] as! Dictionary<String, Any>
        let timestamp: String = TestData.currentDate
        responseMessage["created_at"] = timestamp
        responseMessage["updated_at"] = timestamp
        responseMessage["id"] = id
        responseMessage["text"] = text
        responseMessage["html"] = "<p>\(String(describing: text))</p>\n"
        responseJson["message"] = responseMessage
        return .ok(.json(responseJson))
    }
    
    private func sendEvent(request: HttpRequest) -> HttpResponse {
        let json = String(bytes: request.body, encoding: .utf8)!.json
        let event = json["event"] as! Dictionary<String, Any>
        if event["type"] as! String == "typing.start" {
            return .ok(.text(TestData.getMockResponse(fromFile: "mock_send_typing_start")))
        } else if event["type"] as! String == "typing.stop" {
            return .ok(.text(TestData.getMockResponse(fromFile: "mock_send_typing_stop")))
        } else {
            return .ok(.text("dunno for now"))
        }
    }
    
    @discardableResult
    private func readMessage(request: HttpRequest) -> HttpResponse {
        .ok(.text(TestData.getMockResponse(fromFile: "mock_send_message_read")))
    }
}

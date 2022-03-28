//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

@testable import StreamChat
import XCTest

extension StreamMockServer {
    
    func saveMessage(_ message: [String: Any]) {
        messageList.append(message)
    }
    
    func findMessage(id: String) -> [String: Any] {
        waitForAtLeastOneMessage().filter {
            $0[MessagePayloadsCodingKeys.id.rawValue] as! String == id
        }.first!
    }
    
    func findMessage() -> [String: Any] {
        waitForAtLeastOneMessage().last!
    }
    
    func removeMessage(id: String) {
        let deletedMessage = messageList.filter {
            $0[MessagePayloadsCodingKeys.id.rawValue] as! String == id
        }.first!
        let idKey = MessagePayloadsCodingKeys.id.rawValue
        let deletedIndex = messageList.firstIndex(where: { (message) -> Bool in
            (message[idKey] as! String) == (deletedMessage[idKey] as! String)
        })!
        messageList.remove(at: deletedIndex)
    }
    
    func clearMessageList() {
        messageList = []
    }
    
    private func waitForAtLeastOneMessage() -> [[String: Any]] {
        let endTime = Date().timeIntervalSince1970 * 1000 + 2000
        while messageList.isEmpty && endTime > Date().timeIntervalSince1970 * 1000 {}
        return messageList
    }
}

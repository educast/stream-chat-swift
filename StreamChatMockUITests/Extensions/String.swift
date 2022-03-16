//
//  String.swift
//  StreamChatMockUITests
//
//  Created by Alexey Alter Pesotskiy  on 3/8/22.
//  Copyright © 2022 Stream.io Inc. All rights reserved.
//

import UIKit

extension String {
    
    var json: [String: Any] {
        try! JSONSerialization.jsonObject(with: Data(self.utf8), options: .mutableContainers) as! [String: Any]
    }

    func replace(_ target: String, to: String) -> String {
        self.replacingOccurrences(of: target, with: to, options: NSString.CompareOptions.literal, range: nil)
    }
    
}

//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

import Foundation
@testable import StreamChat

final class TestBuilder {
    let encoder = RequestEncoderSpy(
        baseURL: .unique(),
        apiKey: .init(.unique)
    )
    let decoder = RequestDecoderSpy()
    var sessionConfiguration = URLSessionConfiguration.ephemeral
    let uniqueHeaderValue = String.unique

    func make() -> StreamCDNClient {
        sessionConfiguration.httpAdditionalHeaders?["unique_value"] = uniqueHeaderValue
        RequestRecorderURLProtocolMock.startTestSession(with: &sessionConfiguration)
        URLProtocolMock.startTestSession(with: &sessionConfiguration)

        return StreamCDNClient(
            encoder: encoder,
            decoder: decoder,
            sessionConfiguration: sessionConfiguration
        )
    }
}

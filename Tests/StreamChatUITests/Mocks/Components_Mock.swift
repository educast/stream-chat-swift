//
// Copyright © 2022 Stream.io Inc. All rights reserved.
//

@testable import StreamChatUI

extension Components {
    static var mock: Self {
        var components = Self()
        components.imageLoader = ImageLoaderMock()
        components.videoLoader = VideoLoaderMock()
        return components
    }
    
    var mockImageLoader: ImageLoaderMock { imageLoader as! ImageLoaderMock }
    var mockVideoLoader: VideoLoaderMock { videoLoader as! VideoLoaderMock }
}

Pod::Spec.new do |spec|
  spec.name = "StreamChat"
  spec.version = "4.5.2"
  spec.summary = "StreamChat iOS Client"
  spec.description = "stream-chat-swift is the official Swift client for Stream Chat, a service for building chat applications."

  spec.homepage = "https://getstream.io/chat/"
  spec.license = { :type => "BSD-3", :file => "LICENSE" }
  spec.author = { "getstream.io" => "support@getstream.io" }
  spec.social_media_url = "https://getstream.io"

  spec.swift_version = "5.2"
  spec.ios.deployment_target  = '11.0'
  spec.osx.deployment_target  = '10.15'
  spec.requires_arc = true

  spec.framework = "Foundation"
  spec.ios.framework = "UIKit"

  spec.module_name = "StreamChat"
  spec.source = { :path => '.' }
  spec.source_files  = ["Sources/StreamChat/**/*.swift", "Sources/StreamStarscream/**/*.swift"]
  spec.exclude_files = ["Sources/StreamChat/**/*_Tests.swift", "Sources/StreamChat/**/*_Mock.swift"]
  spec.resource_bundles = { "StreamChat" => ["Sources/StreamChat/**/*.xcdatamodeld"] }
end

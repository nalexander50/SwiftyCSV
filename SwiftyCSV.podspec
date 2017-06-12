Pod::Spec.new do |spec|
  spec.name = "SwiftyCSV"
  spec.version = "0.0.1"
  spec.summary = "Swift CSV Parser"
  spec.homepage = "https://github.com/nalexander50/SwiftyCSV"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Nick Alexander" => 'alexander50@live.com' }
  spec.social_media_url = "http://twitter.com/nalexander50"

  spec.platform = :ios, '8.0'

  spec.source = { git: "https://github.com/nalexander50/SwiftyCSV.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "SwiftyCSV/**/*.swift"
end
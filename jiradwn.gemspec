lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jiradwn/version'

Gem::Specification.new do |s|
  s.name = 'jiradwn'
  s.version = Jiradwn::VERSION.version
  s.summary = 'Jira tool to backup tickets and download from Webdav'
  s.authors = ["Aaron Baer", "Heavy Water Operations"]
  s.email = 'oss@hw-ops.com'
  s.homepage = 'http://github.com/heavywater/jiradwn'
  s.description = 'Jira download tool'
  s.files = Dir['**/*']
  s.require_paths = ["lib"]
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
end

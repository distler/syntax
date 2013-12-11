require './lib/syntax/version'

Gem::Specification.new do |s|

  s.name = 'syntax'
  s.version = Syntax::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.summary =
    "Syntax is Ruby library for performing simple syntax highlighting."
  s.files = Dir.glob("{data,lib,test}/**/*")
  s.files << "README.rdoc"
  s.files << "LICENSE"
  s.files << "CHANGELOG"
  s.require_path = 'lib'
  s.autorequire = 'syntax'

  s.has_rdoc=true

  s.test_file = 'test/ALL-TESTS.rb'

  s.author = "Jamis Buck"
  s.email = "jamis@jamisbuck.org"

end


lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "has_unpublished_password/version"

Gem::Specification.new do |spec|
  spec.name          = "has_unpublished_password"
  spec.version       = HasUnpublishedPassword::VERSION
  spec.authors       = ["Daniel Heath"]
  spec.email         = ["daniel@heath.cc"]

  spec.summary       = %q{Prevent the use of passwords found in the HIBP breach dataset}
  spec.description   = %q{Adds a new validation for ActiveRecord, 'has_unpublished_password'}
  spec.homepage      = "https://github.com/danielheath/has_unpublished_password"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|data)/}) } +
    Dir.glob('serialized-top-11200000-p*.bloom')
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "> 1.17"
  spec.add_development_dependency "rake", "> 10.0"
  spec.add_development_dependency "minitest", "> 5.0"
  spec.add_dependency "ruby-bitfield"
end

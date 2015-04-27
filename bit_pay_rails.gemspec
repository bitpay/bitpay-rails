$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bit_pay_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bitpay-rails"
  s.version     = BitPayRails::VERSION
  s.authors     = ["BitPay, Inc."]
  s.email       = ["integrations@bitpay.com"]
  s.homepage    = "https://bitpay.com"
  s.summary     = "Use bitcoin with BitPay"
  s.description = "Basic connector to the BitPay cryptographic API"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"
  s.add_dependency "bitpay-sdk", "~> 2.4.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "minitest-rspec_mocks"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "webmock"
end

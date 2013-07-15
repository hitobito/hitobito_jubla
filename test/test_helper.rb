# Configure Rails Environment
require File.expand_path('../../app_root', __FILE__)
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
ENV["RAILS_ENV"] = "test"
require File.expand_path('config/environment', ENV['APP_ROOT'])
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  self.reset_fixture_path File.expand_path("../../spec/fixtures", __FILE__)
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

end

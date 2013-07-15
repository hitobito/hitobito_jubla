# Configure Rails Environment
require File.expand_path('../../app_root', __FILE__)
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require File.join(ENV["APP_ROOT"], 'spec', 'spec_helper.rb')

RSpec.configure do |config|
  config.fixture_path = File.expand_path("../fixtures", __FILE__)
end

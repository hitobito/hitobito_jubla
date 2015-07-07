# encoding: utf-8

#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require File.expand_path('../app_root', __FILE__)

source "http://rubygems.org"

# Declare your gem's dependencies in jubla_jubla.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Load application Gemfile for all application dependencies.
eval File.read(File.expand_path('Gemfile', ENV['APP_ROOT']))

group :development, :test do
  # Explicitly define the path for dependencies on other wagons.
  gem 'hitobito_youth', path: "#{ENV['APP_ROOT']}/../"
end

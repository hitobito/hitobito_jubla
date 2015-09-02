# encoding: utf-8

#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your wagon's version:
require 'hitobito_jubla/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  # rubocop:disable SingleSpaceBeforeFirstArg
  s.name        = 'hitobito_jubla'
  s.version     = HitobitoJubla::VERSION
  s.authors     = ['Pascal Zumkehr']
  s.email       = ['zumkehr@puzzle.ch']
  s.summary     = 'Jubla organization specific features'
  s.description = 'Jubla organization specific features'

  s.files       = Dir['{app,config,db,lib}/**/*'] + ['Rakefile']
  s.add_dependency 'hitobito_youth'

  # Do not specify test files due to too long file names
  # s.test_files  = Dir["{test,spec}/**/*"]
  # rubocop:enable SingleSpaceBeforeFirstArg
end

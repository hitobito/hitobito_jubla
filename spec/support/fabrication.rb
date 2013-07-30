# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

Fabrication.configure do |config|
  config.fabricator_path = ['spec/fabricators', '../hitobito_jubla/spec/fabricators']
  config.path_prefix = Rails.root
end

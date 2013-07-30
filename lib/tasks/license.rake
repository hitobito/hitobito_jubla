# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

namespace :app do
  namespace :license do
    task :config do
      @licenser = Licenser.new('hitobito_jubla',
                               'Jungwacht Blauring Schweiz',
                               'https://github.com/hitobito/hitobito_jubla')
    end
  end
end
# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

namespace :zeus do
  task :remove do
    rm "zeus.json"
    rm "config/boot.rb"
    rm "config/application.rb"
    rm "config/environment.rb"
    rm "config/environments"
  end
  task :add do
    sh "ln -s ../../../zeus.json"
    sh "ln -s ../../../../config/boot.rb config/boot.rb"
    sh "ln -s ../../../../config/application.rb config/application.rb"
    sh "ln -s ../../../../config/environment.rb config/environment.rb"
    sh "ln -s ../../../../config/environments config/environments"
  end
end
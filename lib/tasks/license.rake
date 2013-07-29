# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is
#  licensed under the Affero General Public License version 3 or later.
#  See the COPYING file.


namespace :app do
  namespace :license do
    task :config do
      ENV['COPYRIGHT_SOURCE'] ||= 'https://github.com/hitobito/hitobito_jubla'

      ENV['PREAMBLE'] = <<-END.strip
Copyright (c) 2012-#{Time.now.year}, #{ENV['COPYRIGHT_HOLDER']}. This file is
part of Hitobito and licensed under the Affero General Public License version 3
or later. See the COPYING file at the top-level directory or at
#{ENV['COPYRIGHT_SOURCE']}.
END
    end
  end
end
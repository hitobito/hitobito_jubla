# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module JublaOst
  class Config
    class << self
      def database
        config['database']
      end

      def kanton_id(shortname)
        config['kanton'][shortname.downcase] || raise("No canton '#{shortname}' found")
      end

      def qualification_kind_id(shortname)
        config['qualification_kinds'][shortname.upcase]
      end

      def event_kind_id(shortname)
        config['event_kinds'][shortname.upcase]
      end

      def config
        @config ||= YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))
      end
    end
  end
end
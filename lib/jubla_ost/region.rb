# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module JublaOst
  class Region < Base
    self.table_name = 'tRegion'
    self.primary_key = 'REID'

    # Regions starting with this prefix correspond to cantons
    CANTON_PREFIX = 'Kantonale FG '

    class << self
      def migrate
        states.each do |legacy_state|
          state = Group::State.find(Config.kanton_id(legacy_state.Kanton))
          JublaOst::Schar.migrate_state(state, legacy_state)

          regions(legacy_state.Kanton).each do |legacy_region|
            region = Group::Region.new(name: legacy_region.Region)
            region.parent = state
            region.save!
            JublaOst::Schar.migrate_region(region, legacy_region)
          end
        end
      end

      def states
        where('Region LIKE ?', "#{CANTON_PREFIX}%")
      end

      def regions(canton)
        where('Region NOT LIKE ?', "#{CANTON_PREFIX}%").
        where('Kanton = ?', canton.upcase)
      end
    end
  end
end
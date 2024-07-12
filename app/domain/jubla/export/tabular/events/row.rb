#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Export::Tabular::Events
  module Row
    extend ActiveSupport::Concern

    included do
      dynamic_attributes[/^advisor_/] = :contactable_attribute
    end

    def advisor
      # Only Event::Course provides restricted advisor role
      entry.try(:advisor)
    end
  end
end

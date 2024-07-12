#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Event::Camp::KindsController < SimpleCrudController
  self.permitted_attrs = [:label]

  private

  def list_entries
    super.list
  end

  class << self
    def model_class
      Event::Camp::Kind
    end
  end
end

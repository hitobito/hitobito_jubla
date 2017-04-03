# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Export::Tabular::People::OriginatingGroups

  # Overriding id in order to display group name in csv export
  def originating_flock_id
    entry.originating_flock.to_s
  end

  # Overriding id in order to display group name in csv export
  def originating_state_id
    entry.originating_state.to_s
  end

end

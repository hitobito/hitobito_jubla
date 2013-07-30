# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

class Event::Camp < Event

  # This statement is required because this class would not be loaded otherwise.
  require_dependency 'event/camp/role/coach'
  require_dependency 'event/camp/kind'


  attr_accessible :number, :coach_id, :kind_id

  self.kind_class = Event::Camp::Kind

  include Event::RestrictedRole
  restricted_role :coach, Event::Camp::Role::Coach

  belongs_to :kind, class_name: 'Event::Camp::Kind'

end

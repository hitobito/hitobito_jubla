# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Event::ParticipationDecorator
  extend ActiveSupport::Concern

  included do
    alias_method_chain :qualification_link, :status
    alias_method_chain :originating_group, :state
  end

  def qualification_link_with_status(group)
    if event.qualification_possible?
      qualification_link_without_status(group)
    else
      h.icon(qualified? ? :ok : :minus)
    end
  end

  def originating_group_with_state
    if group = person.primary_group
      group.layer_hierarchy[1] # second layer are states
    end
  end

end

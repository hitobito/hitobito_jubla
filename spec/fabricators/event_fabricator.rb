# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# == Schema Information
#
# Table name: events
#
#  id                     :integer          not null, primary key
#  group_id               :integer          not null
#  type                   :string(255)
#  name                   :string(255)      not null
#  number                 :string(255)
#  motto                  :string(255)
#  cost                   :string(255)
#  maximum_participants   :integer
#  contact_id             :integer
#  description            :text
#  location               :text
#  application_opening_at :date
#  application_closing_at :date
#  application_conditions :text
#  kind_id                :integer
#  state                  :string(60)
#  priorization           :boolean          default(FALSE), not null
#  requires_approval      :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  participant_count      :integer          default(0)
#

Fabricator(:camp, from: :event, class_name: :'Event::Camp') do
  groups { [Group.all_types.detect {|t| t.event_types.include?(Event::Camp) }.first] }
end

Fabricator(:jubla_course, from: :course) do
  application_contact do |attrs|

    contact_groups = []
    groups = attrs[:groups]
    groups.each do |g|
      if type = g.class.contact_group_type
        state_agencies = g.children.without_deleted.where(type: type.sti_name)
        contact_groups.concat(state_agencies)
      end
    end
    contact_groups.sample

  end
end

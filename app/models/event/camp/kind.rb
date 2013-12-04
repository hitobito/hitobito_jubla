# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

# == Schema Information
#
# Table name: event_camp_kinds
#
#  id          :integer          not null, primary key
#  label       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted_at  :datetime
#
class Event::Camp
  class Kind < ActiveRecord::Base

    # We have to define this since it uses table_name event_kinds by default
    self.table_name = 'event_camp_kinds'

    acts_as_paranoid
    extend Paranoia::RegularScope

    attr_accessible :label

    has_many :events

    ### INSTANCE METHODS
    def to_s
      label
    end

    # Soft destroy if events exist, otherwise hard destroy
    def destroy
      if events.exists?
        super
      else
        destroy!
      end
    end
  end

end

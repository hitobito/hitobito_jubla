#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.
# == Schema Information
#
# Table name: event_camp_kinds
#
#  id         :integer          not null, primary key
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class Event::Camp
  class Kind < ActiveRecord::Base
    # We have to define this since it uses table_name event_kinds by default
    self.table_name = "event_camp_kinds"

    acts_as_paranoid
    extend Paranoia::RegularScope

    has_many :events

    validates_by_schema

    def self.list
      order(:deleted_at, :label)
    end

    ### INSTANCE METHODS
    def to_s
      label
    end

    # Soft destroy if events exist, otherwise hard destroy
    def destroy
      if events.exists?
        super
      else
        really_destroy!
      end
    end
  end
end

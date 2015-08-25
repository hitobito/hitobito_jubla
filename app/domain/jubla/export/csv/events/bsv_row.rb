# encoding: utf-8

#  Copyright (c) 2012-2015, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::Export::Csv::Events
  module BsvRow
    extend ActiveSupport::Concern

    included do
      delegate :total_day_count, :total_participant_count,
               :total_leader_count, :cook_count, :speaker_count,
               to: :info
    end

  end
end

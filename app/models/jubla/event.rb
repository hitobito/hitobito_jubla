# encoding: utf-8

#  Copyright (c) 2012-2015, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::Event
  extend ActiveSupport::Concern

  module ClassMethods

    def up_to_a_month_ago
      midnight = Time.zone.now.midnight
      joins(:dates).
        where('event_dates.start_at >= ? OR event_dates.finish_at >= ?',
              midnight - 1.month,
              midnight - 1.month)
    end

  end
end

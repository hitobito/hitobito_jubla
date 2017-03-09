# encoding: utf-8

#  Copyright (c) 2012-2015, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Event do

  let(:event)   { Fabricate(:jubla_course) }

  context '#up_to_a_month_ago' do

    it 'find event 20 days ago' do
      event.dates.first.update(finish_at: Time.now - 20.day)
      expect(::Event.up_to_a_month_ago.count).to eq(1)
    end

    it 'not find event 40 days ago' do
      event.dates.first.update(finish_at: Time.now - 40.day)
      expect(::Event.up_to_a_month_ago.count).to eq(0)
    end

  end

end

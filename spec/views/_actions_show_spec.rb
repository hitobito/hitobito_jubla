# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe 'events/_actions_show.html.haml' do

  let(:participant) { people(:top_leader) }
  let(:participation) { Fabricate(:event_participation, person: participant) }
  let(:user) { participant }
  let(:event) { participation.event }
  let(:group) { event.groups.first }

  context 'to sign out' do

    before do
      event.update(application_opening_at: Time.now - 10.day,
                   application_closing_at: Time.now + 5.day,
                   signout_active: true )
    end

    it 'in possible time' do
      expect(response).to eq 'Du bist für diesen Anlass angemeldet'
    end

    before do
      event.update(application_opening_at: Time.now - 10.day,
                   application_closing_at: Time.now - 5.day )
    end

    it 'in unpossible time' do
      expect(response).to eq ""
    end

  end

end

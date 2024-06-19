# frozen_string_literal: true

#  Copyright (c) 2024-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Subscriber::GroupController do

  let(:group) { groups(:be) }
  let(:list) {  MailingList.create!(group: group, name: 'be') }

  subject { response.body }

  before do
    Group::StateAgency::Leader.create!(group: groups(:be_agency), person: people(:top_leader))
    sign_in(people(:top_leader))
    get :query, params: { q: 'Nor', group_id: group.id, mailing_list_id: list.id }
  end

  context 'GET query' do

    it 'does not include sister group or their descendants' do
      is_expected.to_not match(/Nordostschweiz/)
      is_expected.to_not match(/Nordostschweiz → AST/)
      is_expected.to_not match(/Nordostschweiz → Kalei/)
    end

  end
end

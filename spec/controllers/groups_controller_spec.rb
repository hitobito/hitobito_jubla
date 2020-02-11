# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'
describe GroupsController do
  let(:flock) { groups(:bern) }
  let(:leader) { Fabricate(Group::Flock::Leader.name.to_sym, group: flock).person }

  before { sign_in(leader) }

  it '#edit - loads advisors and coaches' do
    get :edit, params: { id: flock.id }
    expect(assigns(:coaches)).to eq flock.available_coaches.only_public_data.order_by_name
    expect(assigns(:advisors)).to eq flock.available_advisors.only_public_data.order_by_name
  end

end

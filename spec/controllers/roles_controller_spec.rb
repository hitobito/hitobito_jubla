# encoding: utf-8

#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe RolesController do


  let(:role) { roles(:top_leader) }
  let(:group) { role.group }

  let(:user) { Fabricate(Group::FederalBoard::Member.name.to_sym, group: group).person }

  before { sign_in(user) }

  context 'PUT update' do
    it 'may update special attributes' do
      put :update, group_id: group.id,
                   id: role.id,
                   role: { type: Group::FederalBoard::President.sti_name,
                           label: 'Foo',
                           honorary: true,
                           employment_percent: 50 }

      role = assigns(:role)
      role.should be_kind_of(Group::FederalBoard::President)
      role.employment_percent.should == 50
      role.honorary.should be_true
    end
  end

end

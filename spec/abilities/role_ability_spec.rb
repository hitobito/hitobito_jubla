# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe RoleAbility do

  subject { ability }
  let(:ability) { Ability.new(role.person.reload) }

  describe :alumnus_below_full do
    let(:role) { Fabricate(Group::FederalAlumnusGroup::Leader.name, group: groups(:ch_ehemalige)) }
    let(:group) { groups(:bern_ehemalige) }

    [ Group::FlockAlumnusGroup::Leader,
      Group::FlockAlumnusGroup::GroupAdmin,
      Group::FlockAlumnusGroup::Treasurer,
      Group::FlockAlumnusGroup::Member,
      Group::FlockAlumnusGroup::External,
      Group::FlockAlumnusGroup::DispatchAddress 
    ].each do |role_type|
      it 'can show if role is in alumnus below' do
        role = Fabricate(role_type.name, group: group)
        is_expected.to be_able_to(:show, role)
      end

      it 'can update if role is in alumnus below' do
        role = Fabricate(role_type.name, group: group)
        is_expected.to be_able_to(:update, role)
      end

      it 'can create if role is in alumnus below' do
        role = Fabricate(role_type.name, group: group)
        is_expected.to be_able_to(:create, role)
      end

      it 'can destroy if role is in alumnus below' do
        role = Fabricate(role_type.name, group: group)
        is_expected.to be_able_to(:destroy, role)
      end
    end

    it 'cannot access if role is in alumnus below' do
        role = Fabricate(Group::Flock::Coach.name, group: groups(:bern))
        is_expected.not_to be_able_to(:destroy, role)
        is_expected.not_to be_able_to(:create, role)
        is_expected.not_to be_able_to(:update, role)
        is_expected.not_to be_able_to(:show, role)
    end

  end

end

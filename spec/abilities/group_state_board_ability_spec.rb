# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'


describe PersonAbility do


  subject { ability }
  let(:ability) { Ability.new(role.person.reload) }


  describe :layer_and_below_read do
    let(:role) { Fabricate(Group::StateBoard::Member.name.to_sym, group: groups(:be_board)) }

    context 'in lower layer' do
      it 'may read details in same group' do
        other = Fabricate(Group::StateBoard::Member.name.to_sym, group: groups(:be_board))
        is_expected.to be_able_to(:show_details, other.person.reload)
      end
      
      it 'may read details in other group' do
        other = Fabricate(Group::Flock::Leader.name.to_sym, group: groups(:thun))
        is_expected.to be_able_to(:show_details, other.person.reload)
      end
      
      it 'may not modify in same group' do
        other = Fabricate(Group::StateBoard::Member.name.to_sym, group: groups(:be_board))
        is_expected.not_to be_able_to(:update, other.person.reload)
        is_expected.not_to be_able_to(:update, other)
      end

      it 'may not modify in other group' do
        other = Fabricate(Group::Flock::Leader.name.to_sym, group: groups(:thun))
        is_expected.not_to be_able_to(:update, other.person.reload)
        is_expected.not_to be_able_to(:update, other)
      end
    end
  end
end

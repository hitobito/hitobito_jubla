# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe MailingListAbility do

  let(:user) { role.person }
  let(:group) { role.group }
  let(:list) { Fabricate(:mailing_list, group: group) }

  subject { Ability.new(user.reload) }

  context 'layer and below full' do
    let(:role) { Fabricate(Group::StateAgency::Leader.name.to_sym, group: groups(:be_agency)) }

    context 'in own group' do
      it 'may show mailing lists' do
        is_expected.to be_able_to(:show, list)
      end

      it 'may update mailing lists' do
        is_expected.to be_able_to(:update, list)
      end

      it 'may index subscriptions' do
        is_expected.to be_able_to(:index_subscriptions, list)
      end

      it 'may create subscriptions' do
        is_expected.to be_able_to(:create, list.subscriptions.new)
      end
    end

    context 'in group in same layer' do
      let(:group) { groups(:be_board) }

      it 'may show mailing lists' do
        is_expected.to be_able_to(:show, list)
      end

      it 'may update mailing lists' do
        is_expected.to be_able_to(:update, list)
      end

      it 'may index subscriptions' do
        is_expected.to be_able_to(:index_subscriptions, list)
      end

      it 'may create subscriptions' do
        is_expected.to be_able_to(:create, list.subscriptions.new)
      end
    end

    context 'in group in lower layer' do
      let(:group) { groups(:bern) }

      it 'may not show mailing lists' do
        is_expected.not_to be_able_to(:show, list)
      end

      it 'may not update mailing lists' do
        is_expected.not_to be_able_to(:update, list)
      end

      it 'may not index subscriptions' do
        is_expected.not_to be_able_to(:index_subscriptions, list)
      end

      it 'may not create subscriptions' do
        is_expected.not_to be_able_to(:create, list.subscriptions.new)
      end
    end

    context 'in group in upper layer' do
      let(:group) { groups(:ch) }

      it 'may not show mailing lists' do
        is_expected.not_to be_able_to(:show, list)
      end

      it 'may not update mailing lists' do
        is_expected.not_to be_able_to(:update, list)
      end

      it 'may not index subscriptions' do
        is_expected.not_to be_able_to(:index_subscriptions, list)
      end

      it 'may not create subscriptions' do
        is_expected.not_to be_able_to(:create, list.subscriptions.new)
      end
    end
  end

  context 'group full' do
    let(:role) { Fabricate(Group::StateProfessionalGroup::Leader.name.to_sym, group: groups(:be_security)) }

    context 'in own group' do
      it 'may show mailing lists' do
        is_expected.to be_able_to(:show, list)
      end

      it 'may update mailing lists' do
        is_expected.to be_able_to(:update, list)
      end

      it 'may index subscriptions' do
        is_expected.to be_able_to(:index_subscriptions, list)
      end

      it 'may create subscriptions' do
        is_expected.to be_able_to(:create, list.subscriptions.new)
      end
    end

    context 'in group in same layer' do
      let(:group) { groups(:be_board) }

      it 'may not show mailing lists' do
        is_expected.not_to be_able_to(:show, list)
      end

      it 'may not update mailing lists' do
        is_expected.not_to be_able_to(:update, list)
      end

      it 'may not index subscriptions' do
        is_expected.not_to be_able_to(:index_subscriptions, list)
      end

      it 'may not create subscriptions' do
        is_expected.not_to be_able_to(:create, list.subscriptions.new)
      end
    end

    context 'in group in lower layer' do
      let(:group) { groups(:bern) }

      it 'may not show mailing lists' do
        is_expected.not_to be_able_to(:show, list)
      end

      it 'may not update mailing lists' do
        is_expected.not_to be_able_to(:update, list)
      end

      it 'may not index subscriptions' do
        is_expected.not_to be_able_to(:index_subscriptions, list)
      end

      it 'may not create subscriptions' do
        is_expected.not_to be_able_to(:create, list.subscriptions.new)
      end
    end

    context 'in group in upper layer' do
      let(:group) { groups(:ch) }

      it 'may not show mailing lists' do
        is_expected.not_to be_able_to(:show, list)
      end

      it 'may not update mailing lists' do
        is_expected.not_to be_able_to(:update, list)
      end

      it 'may not index subscriptions' do
        is_expected.not_to be_able_to(:index_subscriptions, list)
      end

      it 'may not create subscriptions' do
        is_expected.not_to be_able_to(:create, list.subscriptions.new)
      end
    end

    context 'destroyed group' do
      let(:group) { groups(:ausserroden) }
      let(:list) {  Fabricate(:mailing_list, group: groups(:ch)) }

      before { list; group.destroy }

      it 'may not create mailing list' do
        is_expected.not_to be_able_to(:create, list)
      end

      it 'may not update mailing list' do
        is_expected.not_to be_able_to(:update, list)
      end

      it 'may not create subscription' do
        is_expected.not_to be_able_to(:create, list.subscriptions.new)
      end
    end
  end
end

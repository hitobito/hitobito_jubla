# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Role do

  describe Group::Flock::Leader do
    subject { Group::Flock::Leader }

    it { is_expected.to be_member }
    it { is_expected.to be_visible_from_above }

    its(:permissions) { should ==  [:layer_and_below_full, :contact_data, :approve_applications] }

    it 'may be created for flock' do
      role = Fabricate.build(subject.name.to_sym, group: groups(:bern))
      expect(role).to be_valid
    end

    it 'may not be created for region' do
      role = Fabricate.build(subject.name.to_sym, group: groups(:city))
      expect(role).not_to be_valid
      expect(role).to have(1).error_on(:type)
    end
  end

  describe Group::Region::External do
    subject { Group::Region::External }

    its(:kind) { should == :external }
    it { is_expected.not_to be_member }
    it { is_expected.not_to be_visible_from_above }

    its(:permissions) { should ==  [] }

    it 'may be created for region' do
      role = Fabricate.build(subject.name.to_sym, group: groups(:city))
      expect(role).to be_valid
    end
  end

  describe Group::Region::Alumnus do
    subject { Group::Region::Alumnus }

    it { is_expected.to be_alumnus }
    it { is_expected.not_to be_member }
    it { is_expected.to be_visible_from_above }

    its(:permissions) { should ==  [:group_read] }

    it 'may be created for region' do
      role = Fabricate.build(subject.name.to_sym, group: groups(:city))
      expect(role).to be_valid
    end
  end

  describe '#all_types' do
    subject { Role.all_types }

    it 'starts with top most role' do
      expect(subject.first).to eq(Group::Federation::GroupAdmin)
    end

    it 'finishes with bottom most role' do
      expect(subject.last).to eq(Group::SimpleGroup::DispatchAddress)
    end
  end

  context '#destroy' do
    let(:role) { Fabricate(role_class.name.to_s, group: groups(:bern), created_at: created_at) }
    let(:role_class) { Group::Flock::Leader }
    let(:created_at) { Time.zone.now }

    context 'young role' do
      it 'deletes from database' do
        expect { role.destroy }.not_to change { Group::Flock::Alumnus.count }
        expect(Role.with_deleted.where(id: role.id)).not_to be_exists
      end
    end
  end
end

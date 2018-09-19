# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Group::AlumnusGroup do

  let(:parent_group) { groups(:bern) }

  before do
    allow_any_instance_of(Person).to receive(:years).and_return(15)
  end

  context '#destroy' do
    let(:group) { groups(:bern_ehemalige) }

    it 'may not destroy if group is last alumnus group in layer' do
      expect { group.destroy }.not_to change { Group.without_deleted.count }
    end

    it 'may destroy group if other alumnus group exists in layer' do
      Group::FlockAlumnusGroup.create!(name: 'test_group', parent: groups(:bern))
      expect { group.destroy }.to change { Group.without_deleted.count }.by(-1)
    end

    it 'may always destroy nested alumnus group' do
      nested = Group::AlumnusGroup.create!(name: 'test_group', parent: group)
      expect { nested.destroy }.to change { Group.without_deleted.count }.by(-1)
    end
  end

  context 'alumnus group moving' do
    let(:created_at) { Time.zone.now - Settings.role.minimum_days_to_archive.days - 1.day }
    let!(:role) do
      Fabricate(Group::Flock::Leader.to_s,
                group: groups(:bern),
                created_at: created_at)
    end

    context 'single role' do
      describe 'moves to alumnus group' do
        it 'deletes old role' do
          expect_any_instance_of(AlumniMailJob).to receive(:enqueue!).and_call_original
          expect { role.destroy }.to change(Group::Flock::Leader, :count).by(-1)
        end

        it 'creates alumnus role' do
          expect { role.destroy }.to change(Group::FlockAlumnusGroup::Member, :count).by(1)
        end

        it 'creates new background job' do
          expect_any_instance_of(AlumniMailJob).to receive(:enqueue!).and_call_original
          expect { role.destroy }.to change(Delayed::Job, :count).by(1)
          expect(Delayed::Job.first.run_at).to be_within(10.seconds).of(1.day.from_now)
        end
      end

      it 'moves to alumnus group if not old enough but no child' do
        allow_any_instance_of(Person).to receive(:years).and_return(14)
        expect { role.destroy }.to change(Group::FlockAlumnusGroup::Member, :count).by(1)
      end

      it 'moves child to alumnus group if old enough' do
        role = Fabricate(Group::ChildGroup::Child.name.to_s,
                         group: groups(:asterix),
                         created_at: created_at)

        expect { role.destroy }.to change(Group::FlockAlumnusGroup::Member, :count).by(1)
      end

      it 'unless child not old enough' do
        allow_any_instance_of(Person).to receive(:years).and_return(14)
        role = Fabricate(Group::ChildGroup::Child.name.to_s,
                         group: groups(:asterix),
                         created_at: created_at)

        expect { role.destroy }.not_to change(Group::FlockAlumnusGroup::Member, :count)
      end

      it 'unless child has no birthday' do
        allow_any_instance_of(Person).to receive(:years)
        role = Fabricate(Group::ChildGroup::Child.name.to_s,
                         group: groups(:asterix),
                         created_at: created_at)

        expect { role.destroy }.not_to change(Group::FlockAlumnusGroup::Member, :count)
      end

      it 'unless alumnus group' do
        role = Fabricate(Group::FlockAlumnusGroup::Leader.name.to_s,
                         group: groups(:bern_ehemalige),
                         created_at: created_at)

        expect { role.destroy }.to change(Group::FlockAlumnusGroup::Leader, :count).by(-1)
      end

      it 'does not create job if saving new role fails' do
        expect_any_instance_of(AlumniMailJob).not_to receive(:enqueue!).and_call_original
        allow_any_instance_of(Role).to receive(:save).and_return(false)
        role.destroy
      end
    end
  end
end

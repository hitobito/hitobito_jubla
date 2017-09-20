# encoding: utf-8

#  Copyright (c) 2012-2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Group::AlumnusGroup do

  let(:parent_group) { groups(:bern) }

  context '#destroy' do
    it 'destroy if not last alumnus group in layer' do
      Group::FlockAlumnusGroup.create(name: 'test_group', parent_id: parent_group.id)
      alumnus_group2 = Group::FlockAlumnusGroup.create(name: 'test_group2',
                                                       parent_id: parent_group.id)

      expect(alumnus_group2.destroy).not_to be false
      expect(Group.without_deleted.where(id: alumnus_group2.id)).not_to exist
    end

    it 'cannot destroy if last alumnus group in layer' do
      alumnus_group = groups(:bern_ehemalige)

      expect(alumnus_group.destroy).to be false
      expect(Group.without_deleted.where(id: alumnus_group.id)).to exist
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

      it 'unless child role' do
        role = Fabricate(Group::ChildGroup::Child.name.to_s,
                         group: groups(:asterix),
                         created_at: created_at)

        expect { role.destroy }.not_to change { Group::FlockAlumnusGroup::Member.count }
      end

      it 'unless alumnus group' do
        role = Fabricate(Group::FlockAlumnusGroup::Leader.name.to_s,
                         group: groups(:bern_ehemalige),
                         created_at: created_at)

        expect { role.destroy }.to change { Group::FlockAlumnusGroup::Leader.count }.by(-1)
      end

      it 'does not create job if saving new role fails' do
        expect_any_instance_of(AlumniMailJob).not_to receive(:enqueue!).and_call_original
        expect_any_instance_of(Role).to receive(:save).and_return(false)
        role.destroy
      end
    end
  end
end

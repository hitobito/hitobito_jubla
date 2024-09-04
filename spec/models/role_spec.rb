#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe Role do
  let(:some_time_ago) { Time.zone.now - Settings.role.minimum_days_to_archive.days - 1.day }

  describe Group::Flock::Leader do
    subject { Group::Flock::Leader }

    it { is_expected.to be_member }
    it { is_expected.to be_visible_from_above }

    its(:permissions) { should == [:layer_and_below_full, :contact_data, :approve_applications] }

    it "may be created for flock" do
      role = Fabricate.build(subject.name.to_sym, group: groups(:bern))
      expect(role).to be_valid
    end

    it "may not be created for region" do
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

    its(:permissions) { should == [] }

    it "may be created for region" do
      role = Fabricate.build(subject.name.to_sym, group: groups(:city))
      expect(role).to be_valid
    end
  end

  describe "#all_types" do
    subject { Role.all_types }

    it "starts with top most role" do
      expect(subject.first).to eq(Group::Federation::GroupAdmin)
    end

    it "finishes with bottom most role" do
      expect(subject.last).to eq(Group::SimpleGroup::DispatchAddress)
    end
  end

  context "#create" do
    let(:group) { groups(:ch) }

    it "cannot create role without type" do
      person = Fabricate(Group::Flock::Leader.to_s, group: groups(:bern)).person
      role = person.roles.build(type: "", group: group)
      expect(role).not_to be_valid
    end
  end

  context "alumnus group" do
    let(:group) { groups(:ch) }
    let(:alumni_group) { groups(:ch_ehemalige) }

    def self.create_samples
      [%w[Group::FederalBoard::Member federal_board -1],
        %w[Group::FederalBoard::President federal_board -1],
        %w[Group::FederalBoard::GroupAdmin federal_board -1]]
    end

    def self.destroy_samples
      create_samples + [%w[Group::FederalBoard::External federal_board 0],
        %w[Group::FederalBoard::DispatchAddress federal_board 0],
        %w[Group::FederalAlumnusGroup::Leader ch_ehemalige 0]]
    end

    def alumnus_member_count
      Group::FederalAlumnusGroup::Member.where(group: alumni_group).count
    end

    context "create" do
      create_samples.each do |role_type, group, change|
        it "#{role_type} changes alumni members by #{change}" do
          role = Fabricate(Group::FederalAlumnusGroup::Member.to_s, group: alumni_group)
          expect do
            Fabricate(role_type, person: role.person, group: groups(group))
          end.to change { alumnus_member_count }.by(change.to_i)
        end
      end
    end

    context "destroy" do
      let(:too_young) { Settings.alumni_administrations.min_age_for_alumni_member - 1 }

      destroy_samples.each do |role_type, group, change|
        it "#{role_type} changes alumni members by #{change.to_i * -1}, enqueues job" do
          role = Fabricate(role_type, group: groups(group), created_at: some_time_ago)
          expect do
            expect { role.destroy }.to change { Delayed::Job.count }.by(change.to_i * -1)
          end.to change { alumnus_member_count }.by(change.to_i * -1)
        end
      end

      it "still creates alumni member, if person has an alumnus role in same layer" do
        person = Fabricate(Group::OrganizationBoard::Alumnus.sti_name, group: groups(:organization_board)).person
        role = Fabricate(Group::FederalBoard::Member.sti_name, group: groups(:federal_board), created_at: some_time_ago, person: person)
        expect { role.destroy }.to change { alumnus_member_count }.by(1)
      end

      it "does not creates alumni member, if person is too young" do
        role = Fabricate(Group::ChildGroup::Child.sti_name, group: groups(:asterix), created_at: some_time_ago)
        role.person.update(birthday: too_young.years.ago)
        expect { role.destroy }.not_to change { alumnus_member_count }
      end

      it "does not not enqueue mail job when no email is set" do
        role = Fabricate(Group::FederalBoard::Member.sti_name, group: groups(:federal_board), created_at: some_time_ago)
        role.person.update(email: nil)
        expect { role.destroy }.not_to change { Delayed::Job.count }
      end
    end

    context "after alumnus creation" do
      it "create alumni member if new alumni role added" do
        expect do
          Fabricate("Group::FederalBoard::Alumnus", group: groups(:federal_board))
        end.to change { alumnus_member_count }.by(1)
      end

      it "only create one alumni member if multiple new alumni roles added in same layer" do
        expect do
          role = Fabricate("Group::FederalBoard::Alumnus", group: groups(:federal_board))
          Fabricate("Group::OrganizationBoard::Alumnus", group: groups(:organization_board), person: role.person)
        end.to change { alumnus_member_count }.by(1)
      end
    end

    context "after alumnus deletion" do
      it "destroies alumnus membership if last role" do
        role = Fabricate("Group::FederalBoard::Alumnus", group: groups(:federal_board))
        expect do
          role.destroy
        end.to change { alumnus_member_count }.by(-1)
      end

      it "does nothing if there are some alumnus roles left in same layer" do
        role = Fabricate("Group::FederalBoard::Alumnus", group: groups(:federal_board))
        Fabricate("Group::OrganizationBoard::Alumnus", group: groups(:organization_board), person: role.person)
        expect do
          role.destroy
        end.to change { alumnus_member_count }.by(0)
      end
    end

    context "validations" do
      it "allows creating alumnus leader if active role exists in same layer" do
        person = Fabricate(Group::FederalBoard::Member.to_s, group: groups(:federal_board)).person
        role = person.roles.build(type: Group::FederalAlumnusGroup::Leader.to_s, group: alumni_group)
        expect(role).to be_valid
      end

      it "allows creating alumnus member if active role exists in other layer" do
        person = Fabricate(Group::Flock::Leader.to_s, group: groups(:bern)).person
        role = person.roles.build(type: Group::FederalAlumnusGroup::Member.to_s, group: alumni_group)
        expect(role).to be_valid
      end

      it "allows creating alumnus member if only role in same layer is in another alumnus group" do
        group = Group::FederalAlumnusGroup.create!(name: "other", parent: groups(:ch))
        person = Fabricate(Group::FederalAlumnusGroup::Member.to_s, group: group).person
        role = person.roles.build(type: Group::FederalAlumnusGroup::Member.to_s, group: alumni_group)
        expect(role).to be_valid
      end

      it "does not allow creating alumnus member if active role in same layer exists" do
        person = Fabricate(Group::FederalBoard::Member.to_s, group: groups(:federal_board)).person
        role = person.roles.build(type: Group::FederalAlumnusGroup::Member.to_s, group: alumni_group)
        expect(role).not_to be_valid
        expect(role.errors.full_messages.first).to eq "Es befinden sich noch andere aktive Rollen in diesem Layer"
      end
    end
  end

  context "alumnus role" do
    let(:role) { Fabricate(role_class.name.to_s, group: groups(:bern), created_at: some_time_ago) }
    let(:role_class) { Group::Flock::Leader }

    context "create" do
      it "creating active role flags alumnus role as deleted" do
        role = Fabricate(Group::Flock::Alumnus.name, group: groups(:bern), created_at: some_time_ago)
        expect do
          Fabricate(Group::Flock::Leader.name, group: groups(:bern), person: role.person)
        end.to change { Group::Flock::Alumnus.count }.by(-1)
        expect(Role.with_inactive.find(role.id)).to be_present
      end

      it "creating alumnus role does not flag existing alumnus role as deleted" do
        role = Fabricate(Group::Flock::Alumnus.name, group: groups(:bern), created_at: some_time_ago)
        expect do
          Fabricate(Group::Flock::Alumnus.name, group: groups(:bern), person: role.person)
        end.to change { Group::Flock::Alumnus.count }.by(1)
      end
    end

    context "destroy" do
      it "recent role is flagged as deleted without creating alumnus role" do
        role.update(created_at: 1.minute.ago)
        expect { role.destroy }.not_to change { Group::Flock::Alumnus.count }
        expect(Role.with_inactive.where(id: role.id)).not_to be_exists
      end

      it "older role is flagged as deleted without creating alumnus role when another active role exists" do
        Fabricate(role_class.name.to_s, group: groups(:bern), person: role.person)
        expect { role.destroy }.not_to change { Group::Flock::Alumnus.count }
        expect(Role.only_deleted.find(role.id)).to be_present
      end

      it "older role is flagged as deleted and alumnus role is created" do
        expect { role.destroy }.to change { Group::Flock::Alumnus.count }.by(1)
        expect(Role.only_deleted.find(role.id)).to be_present
        expect(Group::Flock::Alumnus.find_by(person_id: role.person_id).label).to eq "Scharleitung"
      end

      context "external role" do
        let(:role_class) { Group::Flock::External }

        it "flags as deleted, does not create alumnus role" do
          expect { role.destroy }.not_to change { Group::Flock::Alumnus.count }
          expect(Role.only_deleted.find(role.id)).to be_present
        end
      end

      context "alumnus role" do
        let(:role_class) { Group::Flock::Alumnus }

        it "can be destroyed, does not creates new alumnus role" do
          expect { role.destroy }.not_to change { Group::Flock::Alumnus.count }
        end
      end
    end
  end

  context "nextcloud" do
    [
      Jubla::Role::GroupAdmin,
      Jubla::Role::Coach,
      Jubla::Role::Leader,
      Jubla::Role::Member,
      Jubla::Role::Treasurer
    ].each do |role_class|
      describe role_class.to_s do
        it "has a unique nextcloud-group" do
          expect(role_class).to include Group::UniqueNextcloudGroup
        end
      end
    end
  end
end

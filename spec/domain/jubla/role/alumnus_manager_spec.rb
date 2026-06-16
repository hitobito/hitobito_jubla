# frozen_string_literal: true

#  Copyright (c) 2021-2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe Jubla::Role::AlumnusManager do
  let(:role) { roles(:flock_leader) }
  let(:person) { role.person }

  subject(:manager) { described_class.new(role) }

  before do
    role.update_columns(end_on: 1.day.ago)
  end

  it "changes role#alumni_processed and creates new alumnus role" do
    expect do
      manager.create
    end.to change { role.reload.alumni_processed }.from(false).to(true)
      .and change { person.reload.roles.select(&:alumnus_member?).count }.by(1)
  end

  context "with another active role in same group" do
    it "changes role#alumni_processed and without creating new alumnus role" do
      Fabricate(Group::Flock::President.to_s, group: groups(:innerroden), person:)

      expect do
        manager.create
      end.to change { role.reload.alumni_processed }.from(false).to(true)
        .and not_change { person.reload.roles.select(&:alumnus_member?).count }
    end
  end

  context "with another active role in same layer" do
    it "changes role#alumni_processed but does not create alumnus group member" do
      other_role = Fabricate(Group::FlockAlumnusGroup::Leader.sti_name, group: groups(:innerroden_ehemalige), person:)
      expect(role.group.layer_group).to eq other_role.group.layer_group

      expect do
        manager.create
      end.to change { role.reload.alumni_processed }.from(false).to(true)
        .and not_change {
               person.reload.roles.where("type LIKE '%::Member'").count
             }
    end
  end
end

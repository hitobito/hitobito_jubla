# frozen_string_literal: true

#  Copyright (c) 2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe AlumniManagerJob do
  subject(:job) { described_class.new }
  let(:person) { role.person }

  let(:role) { roles(:top_leader) }

  it "noops if role is active" do
    expect { job.perform }.not_to change { person.roles.count }
  end

  it "noops if role expires in the future" do
    role.update!(end_on: Time.zone.tomorrow)
    expect { job.perform }.not_to change { person.roles.count }
  end

  it "creates alumni role in group and layer if role expired" do
    role.update!(end_on: Date.yesterday)
    expect { job.perform }.to change { person.roles.count }.by(2)
    expect(person.roles.map(&:type)).to match_array ["Group::FederalBoard::Alumnus", "Group::FederalAlumnusGroup::Member"]
  end

  it "noops if alumni roles have been created" do
    role.update_columns(end_on: Date.yesterday)

    Fabricate(Group::FederalAlumnusGroup::Member.sti_name, person: person, group: groups(:ch_ehemalige))
    Fabricate(Group::FederalBoard::Alumnus.sti_name, person: person, group: groups(:federal_board))
    expect { job.perform }.not_to change { person.roles.count }
  end

  it "deletes alumni roles if role becomes active" do
    role.update_columns(end_on: Date.yesterday)

    Fabricate(Group::FederalAlumnusGroup::Member.sti_name, person: person, group: groups(:ch_ehemalige))
    Fabricate(Group::FederalBoard::Alumnus.sti_name, person: person, group: groups(:federal_board))
    role.update_columns(end_on: nil)

    expect { job.perform }.to change { person.roles.count }.by(-2)
    expect(person.roles.map(&:type)).to match_array ["Group::FederalBoard::Member"]
  end
end

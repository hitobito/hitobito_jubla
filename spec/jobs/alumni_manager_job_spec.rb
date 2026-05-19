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
    role.update_columns(end_on: Time.zone.tomorrow)
    expect { job.perform }.not_to change { person.reload.roles.count }
  end

  it "creates alumni role in group and layer if role expired" do
    role.update_columns(end_on: Date.yesterday)
    expect { job.perform }.to change { person.reload.roles.count }.by(1)
    expect(person.roles.map(&:type)).to match_array ["Group::FederalBoard::Alumnus"]
  end

  it "noops if alumni roles have been created" do
    role.update_columns(end_on: Date.yesterday)

    Fabricate(Group::FederalAlumnusGroup::Member.sti_name, person: person, group: groups(:ch_ehemalige))
    Fabricate(Group::FederalBoard::Alumnus.sti_name, person: person, group: groups(:federal_board))
    expect { job.perform }.not_to change { person.roles.count }
  end

  it "noops if alumni roles have been created and person has active role in different layer" do
    role.update_columns(end_on: Date.yesterday)

    Fabricate(Group::StateAgency::Leader.sti_name, group: groups(:be_agency), person: person)
    Fabricate(Group::FederalAlumnusGroup::Member.sti_name, person: person, group: groups(:ch_ehemalige))
    Fabricate(Group::FederalBoard::Alumnus.sti_name, person: person, group: groups(:federal_board))

    expect { job.perform }.not_to change { person.reload.roles.pluck(:id) }
  end
end

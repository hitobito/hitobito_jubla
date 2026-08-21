# frozen_string_literal: true

#  Copyright (c) 2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"
require HitobitoJubla::Wagon.root.join("lib/tasks/qualis/grant_grundkurs")

describe Qualis::GrantGrundkurs do
  let(:target) { Fabricate(:qualification_kind, label: "Grundkurs", validity: nil) }
  let(:gk_js) { Fabricate(:event_kind, label: "Grundkurs (GK J+S)") }
  let(:gk_bsv) { Fabricate(:event_kind, label: "Grundkurs (GK BSV)") }
  let(:person) { people(:top_leader) }

  subject(:task) do
    described_class.new(target_kind_id: target.id,
      event_kind_ids: [gk_js.id, gk_bsv.id],
      dry_run: dry_run)
  end

  let(:dry_run) { false }

  it "grants the qualification dated at the end of the course" do
    course = create_course(gk_js, 2008)
    participate(course, person)

    expect { task.run }.to change { target_qualifications(person).count }.by(1)

    quali = target_qualifications(person).first
    expect(quali.start_at).to eq(Date.new(2008, 6, 19))
    expect(quali.qualified_at).to eq(Date.new(2008, 6, 19))
    expect(quali.finish_at).to be_nil
    expect(quali.origin).to eq(course.to_s)
  end

  it "grants it for both event kinds" do
    participate(create_course(gk_bsv, 2010), person)

    expect { task.run }.to change { target_qualifications(person).count }.by(1)
  end

  it "grants it once, dated at the earliest course attended" do
    participate(create_course(gk_js, 2015), person)
    participate(create_course(gk_bsv, 2009), person)

    expect { task.run }.to change { target_qualifications(person).count }.by(1)
    expect(target_qualifications(person).first.start_at).to eq(Date.new(2009, 6, 19))
  end

  it "ignores courses before 2002" do
    participate(create_course(gk_js, 2001), person)

    expect { task.run }.not_to change { Qualification.count }
  end

  it "ignores courses of other event kinds" do
    participate(create_course(Fabricate(:event_kind, label: "Coachkurs"), 2010), person)

    expect { task.run }.not_to change { Qualification.count }
  end

  it "ignores non-participant roles" do
    participate(create_course(gk_js, 2010), person, role: Event::Role::Leader)

    expect { task.run }.not_to change { Qualification.count }
  end

  it "skips people who already have the qualification" do
    participate(create_course(gk_js, 2010), person)
    Fabricate(:qualification, person: person, qualification_kind: target,
      start_at: Date.new(2011, 6, 2))

    expect { task.run }.not_to change { Qualification.count }
  end

  it "logs how many qualifications it created" do
    participate(create_course(gk_js, 2010), person)
    participate(create_course(gk_bsv, 2012), Fabricate(:person))

    expect { task.run }.to output(/Created 2 Grundkurs qualifications from 2 courses/).to_stdout
  end

  it "includes participants that were never marked as qualified" do
    participate(create_course(gk_js, 2010), person, qualified: false)

    expect { task.run }.to change { target_qualifications(person).count }.by(1)
  end

  context "dry run" do
    let(:dry_run) { true }

    it "creates nothing" do
      participate(create_course(gk_js, 2010), person)

      expect { task.run }.not_to change { Qualification.count }
    end
  end

  private

  def target_qualifications(person)
    person.qualifications.where(qualification_kind: target)
  end

  def create_course(kind, year)
    start_at = Date.new(year, 6, 11)
    Fabricate(:course, kind: kind,
      dates: [Fabricate(:event_date, start_at: start_at, finish_at: start_at + 8.days)],
      application_contact: groups(:federal_board))
  end

  def participate(course, person, qualified: true, role: Event::Course::Role::Participant)
    Fabricate(:event_participation, event: course, participant: person, qualified: qualified,
      state: :assigned, roles: [role.new])
  end
end

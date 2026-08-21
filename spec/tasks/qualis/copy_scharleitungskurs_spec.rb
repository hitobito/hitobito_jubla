# frozen_string_literal: true

#  Copyright (c) 2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"
require HitobitoJubla::Wagon.root.join("lib/tasks/qualis/copy_scharleitungskurs")

describe Qualis::CopyScharleitungskurs do
  let(:source) { Fabricate(:qualification_kind, label: "Zusatz Scharleitung", validity: nil) }
  let(:target) { Fabricate(:qualification_kind, label: "Scharleitungskurs", validity: nil) }
  let(:person) { people(:top_leader) }

  subject(:task) do
    described_class.new(source_kind_id: source.id, target_kind_id: target.id, dry_run: dry_run)
  end

  let(:dry_run) { false }

  def target_qualifications(person)
    person.qualifications.where(qualification_kind: target)
  end

  it "creates one target qualification per person, dated like the latest source qualification" do
    Fabricate(:qualification, person: person, qualification_kind: source,
      start_at: Date.new(2010, 5, 1))
    Fabricate(:qualification, person: person, qualification_kind: source,
      start_at: Date.new(2015, 8, 3))

    expect { task.run }.to change { target_qualifications(person).count }.by(1)

    quali = target_qualifications(person).first
    expect(quali.start_at).to eq(Date.new(2015, 8, 3))
    expect(quali.qualified_at).to eq(Date.new(2015, 8, 3))
    expect(quali.finish_at).to be_nil
    expect(quali.origin).to eq("Übernommen von Zusatz Scharleitung")
  end

  it "ignores people without the source qualification" do
    other_kind = Fabricate(:qualification_kind, label: "Irgendwas")
    Fabricate(:qualification, person: person, qualification_kind: other_kind)

    expect { task.run }.not_to change { Qualification.count }
  end

  it "skips people who already have the target qualification" do
    Fabricate(:qualification, person: person, qualification_kind: source,
      start_at: Date.new(2010, 5, 1))
    Fabricate(:qualification, person: person, qualification_kind: target,
      start_at: Date.new(2011, 6, 2))

    expect { task.run }.not_to change { Qualification.count }
  end

  context "dry run" do
    let(:dry_run) { true }

    it "creates nothing" do
      Fabricate(:qualification, person: person, qualification_kind: source,
        start_at: Date.new(2010, 5, 1))

      expect { task.run }.not_to change { Qualification.count }
    end
  end
end

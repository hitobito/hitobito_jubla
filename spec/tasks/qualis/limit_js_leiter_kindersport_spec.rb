# frozen_string_literal: true

#  Copyright (c) 2026, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"
require HitobitoJubla::Wagon.root.join("lib/tasks/qualis/limit_js_leiter_kindersport")

describe Qualis::LimitJsLeiterKindersport do
  let(:kind) { Fabricate(:qualification_kind, label: "J+S Leiter*in LS/T Kindersport") }
  let(:person) { people(:top_leader) }
  let(:deadline) { Date.new(2026, 12, 31) }

  subject(:task) { described_class.new(kind_id: kind.id, dry_run: dry_run) }

  let(:dry_run) { false }

  it "caps qualifications expiring after the deadline" do
    quali = create_quali(finish_at: Date.new(2028, 12, 31))

    expect { task.run }.to change { quali.reload.finish_at }.to(deadline)
  end

  it "caps qualifications without expiry" do
    quali = create_quali(finish_at: nil)

    expect { task.run }.to change { quali.reload.finish_at }.from(nil).to(deadline)
  end

  it "leaves qualifications expiring before the deadline untouched" do
    quali = create_quali(finish_at: Date.new(2025, 12, 31))

    expect { task.run }.not_to change { quali.reload.finish_at }
  end

  it "leaves qualifications expiring exactly on the deadline untouched" do
    create_quali(finish_at: deadline)

    expect { task.run }.to output(/Ending 0 /).to_stdout
  end

  it "leaves other qualification kinds untouched" do
    other = Fabricate(:qualification, person: person, start_at: Date.new(2024, 1, 1),
      qualification_kind: Fabricate(:qualification_kind, label: "Irgendwas", validity: 10))

    expect { task.run }.not_to change { other.reload.finish_at }
  end

  context "dry run" do
    let(:dry_run) { true }

    it "changes nothing" do
      quali = create_quali(finish_at: Date.new(2028, 12, 31))

      expect { task.run }.not_to change { quali.reload.finish_at }
    end
  end

  private

  def create_quali(finish_at:)
    Fabricate(:qualification, person: person, qualification_kind: kind,
      start_at: Date.new(2024, 1, 1)).tap do |quali|
      quali.update_column(:finish_at, finish_at)
    end
  end
end

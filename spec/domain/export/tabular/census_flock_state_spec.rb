# frozen_string_literal: true

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require "spec_helper"

describe Export::Tabular::CensusFlockState do
  let(:census_flock) { Export::Tabular::CensusFlockState.new(entries) }
  let(:entries) { Export::Tabular::CensusFlockStateList.new(2012, state.id).entries }
  let(:state) { groups(:be) }

  describe ".headers" do
    subject { census_flock }

    its(:labels) do
      is_expected.to eq ["Region", "Art", "Schar", "Leitende", "Kinder"]
    end
  end

  describe "census flock" do
    it { expect(census_flock.list).to have(3).items }

    it "orders by groups.lft and name" do
      expect(census_flock.list[0][:name]).to eq "Bern"
      expect(census_flock.list[1][:name]).to eq "Muri"
    end

    it "ignores archived group" do
      groups(:bern).update(archived_at: 1.day.ago)
      groups(:thun).update(deleted_at: 1.day.ago)
      expect(census_flock.list).to have(1).items
    end
  end

  describe "mapped items" do
    let(:flock) { groups(:bern) }

    subject { census_flock.list[0] }

    describe "keys and values" do
      its(:keys) do
        is_expected.to eq [:region, :kind, :name, :leader_count, :child_count]
      end

      its(:values) { is_expected.to eq ["Stadt", "Jungwacht", "Bern", 5, 7] }

      its(:values) { is_expected.to have(census_flock.labels.size).items }
    end

    describe "without member count" do
      before { MemberCount.where(flock_id: flock.id).destroy_all }

      its(:values) { is_expected.to eq ["Stadt", "Jungwacht", "Bern", nil, nil] }
    end
  end

  describe "to_csv" do
    subject { Export::Csv::Generator.new(census_flock).call.split("\n") }

    its(:first) do
      is_expected.to match(/Region;Art;Schar;Leitende;Kinder/)
    end
    its(:second) { is_expected.to eq "Stadt;Jungwacht;Bern;5;7" }
  end
end

# frozen_string_literal: true

#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Export::Tabular::CensusFlockState do

  let(:census_flock) { Export::Tabular::CensusFlockState.new(2012) }
  describe '.headers' do
    subject { census_flock }

    its(:labels) do
      should eq ["Region", "Schar", "Leitende", "Kinder"]
    end
  end

  describe 'census flock' do

    it { expect(census_flock.list).to have(5).items }

    it 'orders by groups.lft and name' do
      expect(census_flock.list[0][:name]).to eq 'Ausserroden'
      expect(census_flock.list[1][:name]).to eq 'Bern'
    end
  end

  describe 'mapped items' do
    let(:flock) { groups(:bern) }

    subject { census_flock.list[1] }

    describe 'keys and values' do

      its(:keys) do
        should eq [:region, :name, :leader_count, :child_count]
      end

      its(:values) { should eq ["Stadt", "Bern", 5, 7] }

      its(:values) { should have(census_flock.labels.size).items }
    end

    describe 'without member count' do
      before { MemberCount.where(flock_id: flock.id).destroy_all }

      its(:values) { should eq ["Stadt", "Bern", nil, nil] }
    end
  end

  describe 'to_csv' do

    subject { Export::Csv::Generator.new(census_flock).call.split("\n") }

    its(:first) do
      should match(/Region;Schar;Leitende;Kinder/)
    end
    its(:second) { should eq '"";Ausserroden;;' }
  end

end

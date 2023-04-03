# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

require 'spec_helper'

describe Export::Tabular::CensusFlock do

  let(:census_flock) { Export::Tabular::CensusFlock.new(2012) }
  describe '.headers' do
    subject { census_flock }

    its(:labels) do
      should eq ['Name', 'Kontakt Vorname', 'Kontakt Nachname', 'Adresse', 'PLZ', 'Ort',
                 'Jubla Sachversicherung', 'Jubla Haftpflicht', 'Jubla Vollkasko',
                 'Leitende', 'Kinder']
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
        should eq [:name, :contact_first_name, :contact_last_name, :address, :zip_code, :town,
                   :jubla_property_insurance, :jubla_liability_insurance, :jubla_full_coverage,
                   :leader_count, :child_count]
      end

      its(:values) { should eq ['Bern', nil, nil, nil, nil, nil, false, false, false, 5, 7] }

      its(:values) { should have(census_flock.labels.size).items }
    end

    describe 'address, zip code and town' do
      before { flock.update(address: 'bar', zip_code: 1234, town: 'foo') }

      its(:values) { should eq ['Bern', nil, nil, 'bar', 1234, 'foo', false, false, false, 5, 7] }
    end

    describe 'contact person' do
      before { flock.update_attribute(:contact_id, people(:top_leader).id) }

      its(:values) { should eq ['Bern', 'Top', 'Leader', nil, nil, nil, false, false, false, 5, 7] }
    end

    describe 'insurance attributes' do
      before do
        flock.update_attribute(:jubla_property_insurance, true)
        flock.update_attribute(:jubla_liability_insurance, true)
        flock.update_attribute(:jubla_full_coverage, true)
      end

      its(:values) { should eq ['Bern', nil, nil, nil, nil, nil, true, true, true, 5, 7] }
    end

    describe 'without member count' do
      before { MemberCount.where(flock_id: flock.id).destroy_all }

      its(:values) { should eq ['Bern', nil, nil, nil, nil, nil, false, false, false, nil, nil] }
    end
  end

  describe 'to_csv' do

    subject { Export::Csv::Generator.new(census_flock).call.split("\n") }

    its(:first) do
      should match /Name;Kontakt Vorname;Kontakt Nachname;Adresse;PLZ;Ort;Jubla Sachversicherung;Jubla Haftpflicht;Jubla Vollkasko;Leitende;Kinder/
    end
    its(:second) { should eq 'Ausserroden;;;;;;nein;nein;nein;;' }
  end

end
